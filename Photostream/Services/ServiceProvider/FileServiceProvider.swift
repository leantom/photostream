//
//  FileServiceProvider.swift
//  Photostream
//
//  Created by Mounir Ybanez on 17/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import SwiftyJSON

enum NameSafeSearchAdult: String {
    case VERY_LIKELY = "VERY_LIKELY"
    case VERY_UNLIKELY = "VERY_UNLIKELY"
    case LIKELY = "LIKELY"
    case UNLIKELY = "UNLIKELY"
    case POSSIBLE = "POSSIBLE"
    
}

struct SafeSearchAnnotation {
    var spoof =  "VERY_UNLIKELY"
    var medical = "UNLIKELY"
    var adult = "VERY_UNLIKELY"
    var violence = "VERY_UNLIKELY"
    var isAdult = false
    var isviolence = false
    
    init(dict: JSON) {
        self.spoof = dict["spoof"].string!
        self.medical = dict["medical"].string!
        self.adult = dict["adult"].string!
        self.violence = dict["violence"].string!
        if self.adult == NameSafeSearchAdult.LIKELY.rawValue || self.adult == NameSafeSearchAdult.VERY_LIKELY.rawValue {
            self.isAdult = true
        }
        
        if self.violence == NameSafeSearchAdult.LIKELY.rawValue || self.adult == NameSafeSearchAdult.VERY_LIKELY.rawValue {
            self.isviolence = true
        }
    }
}

struct FileServiceProvider: FileService {
    
    var session: AuthSession
    var googleAPIKey = "AIzaSyAYm5c2fPbmkKBdblYhSYj7B4i9FS_Py10"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    init(session: AuthSession) {
        self.session = session
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String, callback:@escaping ((SafeSearchAnnotation?) -> Void)) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "SAFE_SEARCH_DETECTION"
                    ]
                ]
            ]
        ]
        
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            callback(self.analyzeResults(data))
        }
        
        task.resume()
    }
    
    
     func analyzeResults(_ dataToParse: Data) -> SafeSearchAnnotation? {
        
        // Use SwiftyJSON to parse results
        let json = JSON(data: dataToParse)
        let errorObj: JSON = json["error"]
        
        // Check for errors
        if (errorObj.dictionaryValue != [:]) {
            
        } else {
            let responses: JSON = json["responses"][0]
            let safeSearch = SafeSearchAnnotation(dict: responses["safeSearchAnnotation"])
            return safeSearch
        }
        
        return nil
    }
    
    
    
    
    func uploadJPEGImage(data: FileServiceImageUploadData, track: ((Progress?) -> Void)?, callback: ((FileServiceResult) -> Void)?) {
        var result = FileServiceResult()
        result.uploadId = data.id
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found.")
            callback?(result)
            return
        }
        
        guard let imageData = data.data else {
            result.error = .noDataToUpload(message: "No data to upload.")
            callback?(result)
            return
        }
        
        let userId = session.user.id
        let storageRef = Storage.storage().reference()
        let key = Date.timeIntervalSinceReferenceDate * 1000
        let imagePath = "\(userId)/posts/\(key).jpg"
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let task = storageRef.child(imagePath).putData(imageData, metadata: metadata, completion: { (metadata, error) in
            guard error == nil else {
                result.error = .failedToUpload(message: "Failed upload JPEG image.")
                callback?(result)
                return
            }
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else {
                result.error = .failedToUpload(message: "Image URL does not exist.")
                callback?(result)
                return
            }
            
            let databaseRef = Database.database().reference()
            let key = databaseRef.child("photos").childByAutoId().key
            let path = "photos/\(key)"
            let data: [String: AnyObject] = [
                "id": key as AnyObject,
                "uid": userId as AnyObject,
                "url": imageUrl as AnyObject,
                "height": data.height as AnyObject,
                "width": data.width as AnyObject ]
            databaseRef.child(path).setValue(data)
            
            result.fileId = key
            result.fileUrl = imageUrl
            callback?(result)
        })
        
        guard track != nil else {
            return
        }
        
        task.observe(.progress) { (snapshot) in
            track!(snapshot.progress)
        }
    }

    func uploadURLImage(imgURL: String, track: ((Progress?) -> Void)?, callback: ((FileServiceResult) -> Void)?) {

        var result = FileServiceResult()
        
        let userId = session.user.id
        let databaseRef = Database.database().reference()
        let key = databaseRef.child("photos").childByAutoId().key
        let path = "photos/\(key)"
        let data: [String: AnyObject] = [
            "id": key as AnyObject,
            "uid": userId as AnyObject,
            "url": imgURL as AnyObject,
            "height": 1080 as AnyObject,
            "width": 720 as AnyObject]
        databaseRef.child(path).setValue(data)
        result.fileId = key
        result.fileUrl = imgURL
        callback?(result)
    }

    func uploadAvatarImage(data: FileServiceImageUploadData, track: ((Progress?) -> Void)?, callback: ((FileServiceResult) -> Void)?) {
        var result = FileServiceResult()
        result.uploadId = data.id
        guard session.isValid else {
            result.error = .authenticationNotFound(message: "Authentication not found")
            callback?(result)
            return
        }
        
        guard let imageData = data.data else {
            result.error = .noDataToUpload(message: "No data to upload")
            callback?(result)
            return
        }
        
        let uid = session.user.id
        let storageRef = Storage.storage().reference()
        
        let key = Date.timeIntervalSinceReferenceDate * 1000
        let imagePath = "\(uid)/avatar/\(key).jpg"
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let task = storageRef.child(imagePath).putData(imageData, metadata: metadata, completion: { metadata, error in
            guard error == nil else {
                result.error = .failedToUpload(message: "Failed upload avatar image")
                callback?(result)
                return
            }
            
            guard let avatarUrl = metadata?.downloadURL()?.absoluteString else {
                result.error = .failedToUpload(message: "Avatar URL does not exist")
                callback?(result)
                return
            }
            
            result.fileUrl = avatarUrl
            callback?(result)
        })
        
        guard track != nil else {
            return
        }
        
        task.observe(.progress) { (snapshot) in
            track!(snapshot.progress)
        }
    }
}
