//
//  GoogleDriveViewController.swift
//  Pikme
//
//  Created by Lê An on 8/22/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
import GTMOAuth2
import Kingfisher
import Alamofire

class GoogleDriveViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate  {
    var gTLRDriveService: GTLRDriveService!
    var files = [GTLRDrive_File]()
    var queryContent = ""
    
    let auth = AuthSession()
    var fileService: FileService!
    var postService: PostService!
    var userDrive: GIDGoogleUser!

    @IBOutlet weak var clCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileService = FileServiceProvider(session: auth)
        postService = PostServiceProvider(session: auth)
        clCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        var currentScopes = GIDSignIn.sharedInstance().scopes
        clCollection.delegate = self
        clCollection.dataSource = self
        currentScopes?.append("https://www.googleapis.com/auth/drive")
        GIDSignIn.sharedInstance().scopes = currentScopes
        getListFiles()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            // ...
            print(error)
            return
        } else {
            userDrive = user
            loadFileInFolder()
        }
    }
    
    func loadFileInFolder() {
        let query = GTLRDriveQuery_FilesList.query()
        query.fields = "files(id,name,mimeType,modifiedTime,thumbnailLink,webViewLink,webContentLink),nextPageToken"
        
        query.q = queryContent
        query.pageSize = 1000
        if gTLRDriveService == nil {
            gTLRDriveService = GTLRDriveService()
            gTLRDriveService.authorizer = userDrive.authentication.fetcherAuthorizer()
        }
        gTLRDriveService.executeQuery(query) { (ticket, listsFile, err) in
            if err == nil {
                if let Files = listsFile {
                    for file in (Files as! GTLRDrive_FileList).files! {
                        self.files.append(file)
                    }
                    self.clCollection.reloadData()
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    func getListFiles() {
        if userDrive == nil {
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}

extension GoogleDriveViewController: UICollectionViewDataSource, UICollectionViewDelegate,PostUploadInteractorInput {
    // 1: Success 0: Fail
    func uploadFiles(with data: FileServiceImageUploadData, content: String,success:@escaping(Int)->Void) {
        // Upload first the photo
        fileService.uploadJPEGImage(data: data, track: { (progress) in
            guard progress != nil else {
                return
            }
            
            
        }) { (result) in
            guard let fileId = result.fileId,
                result.error == nil else {
                    return
            }
            
            // Write details of the post
            self.postService.writePost(photoId: fileId, content: content, callback: { (result) in
                success(1)
            })
        }
    }
    
    func upload(with data: FileServiceImageUploadData, content: String) {
    }
    
    
    func uploadURL(with URL: String, content: String) {
        
        // Upload first the photo
        fileService.uploadURLImage(imgURL: URL, track: { (progress) in
            guard progress != nil else {
                return
            }
            
            
        }) { (result) in
            guard let fileId = result.fileId,
                result.error == nil else {
                    return
            }
            
            // Write details of the post
            self.postService.writePost(photoId: fileId, content: content, callback: { (result) in
                guard result.error == nil else {
                    
                    return
                }
                
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let childrenVC = GoogleDriveViewController()
        let file  = files[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let image = cell.image.image!
        if file.mimeType == "image/jpeg" {
            
            
        } else if(file.mimeType == "application/vnd.google-apps.folder") {
            let query = GTLRDriveQuery_FilesList.query()
            query.fields = "files(id,name,mimeType,modifiedTime,thumbnailLink,webViewLink,webContentLink),nextPageToken"
            query.q = String(format: "'%@' in parents and trashed=false", file.identifier!)
            query.pageSize = 1000
            if gTLRDriveService == nil {
                gTLRDriveService = GTLRDriveService()
                gTLRDriveService.authorizer = userDrive.authentication.fetcherAuthorizer()
            }
            gTLRDriveService.executeQuery(query) { (ticket, listsFile, err) in
                if err == nil {
                    self.files.removeAll()
                    if let Files = listsFile {
                        for file in (Files as! GTLRDrive_FileList).files! {
                            self.files.append(file)
                        }
                        // handle
                        let images = self.files.filter({$0.mimeType == "image/jpeg"})
                        var index  = 0
                        for fileImage in images {
                            self.downloadFile(idFile: fileImage.identifier!, success: { (data) in
                                
                                var imageData: FileServiceImageUploadData {
                                    var dataUpload = FileServiceImageUploadData()
                                    dataUpload.data = data
                                    dataUpload.width = Float(1080)
                                    dataUpload.height = Float(720)
                                    return dataUpload
                                }
                                self.uploadFiles(with: imageData, content: "Perfect world @@", success: { (success) in
                                    index = index + 1
                                    if index == images.count {
                                        let alert = UIAlertController(title: "Alert", message: "Successfully", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                            
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                })
                                
                            })
                        }
                    }
                }
            }
        } else {
            childrenVC.queryContent = String(format: "'%@' in parents and trashed=false", file.identifier!)
        }
    }
    
    func downloadFile(idFile: String,success:@escaping(Data)->Void) {
        let gtl = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: idFile)
        gTLRDriveService.executeQuery(gtl) { (ticket, file, err) in
            if err == nil {
                if let dataResult = file {
                    success((dataResult as! GTLRDataObject).data)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let file  = files[indexPath.row]
        setupImage(file: file, imageView: cell.image)
        cell.lblTitle.text = file.name
        return cell
    }
    
    func setupImage(file: GTLRDrive_File,imageView: UIImageView) {
        if file.thumbnailLink == nil {
            return
        }
        guard let downloadUrl = URL(string: file.thumbnailLink!) else {
            imageView.image =  nil
            return
        }
        
        let resource = ImageResource(downloadURL: downloadUrl)
        imageView.kf.setImage(
            with: resource,
            placeholder: nil,
            options: nil,
            progressBlock: nil,
            completionHandler: nil)
    }
    
    
}

extension GoogleDriveViewController {
    func getQuotes(success:@escaping(String)->Void) {
        Alamofire.request("https://talaikis.com/api/quotes/random/").responseJSON { (json) in
            if let value = json.result.value {
                success((value as! NSDictionary).object(forKey: "quote") as! String)
            }
            print(json)
        }
    }
}
