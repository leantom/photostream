//
//  NotificationServiceProvider.swift
//  Pikme
//
//  Created by Lê An on 8/12/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import Foundation
import FirebaseMessaging
import Alamofire

enum TypePushNotification: String {
    case Comment
    case Following
    case Like
    case NewPost
}

struct NotificationServiceProvider: NotificationService {
    func postComment(from: User, token: String) {
        let service = ServiceHTTPManual()
        service.requestPostNofication(from: from, to: token, type: .Comment)
    }
    
    func likePosts(from: User, token: String) {
        let service = ServiceHTTPManual()
        service.requestPostNofication(from: from, to: token, type: .Like)
    }
    
    func post(from: User, token: String) {
        
    }
}

class ServiceHTTPManual: NSObject {
    static let keyService = "AAAAYiFGP9c:APA91bFanRyozNlz-6zhAFu_yWdxSkvU0AStbrkSfj5iv6N6HE2zN4qFMxAdq65lYznb2znEtMyz9B16xl0njsXRwWlWr2Tsocb6mIGB14oNRlAIXr3SAjYH8pZV8djuJdfANg8ldyBC03Hc0b3E8Bo7EjWoateZug"
    /**
     to: Device token
    */
  public func requestPostNofication(from:User, to: String, type: TypePushNotification) {
        
    let headers = [
            "Authorization": "key=\(ServiceHTTPManual.keyService)",
            "Content-Type": "application/json"
        ]
    var titleContent = ""
    switch type {
    case .Comment:
        titleContent = String(format: "%@ đã bình luận trong 1 photo của bạn", from.displayName)
    case .Following:
        titleContent = String(format: "%@ đã follow  bạn", from.displayName)
    case .Like:
        titleContent = String(format: "%@ đã like 1 photo của bạn", from.displayName)
    default:
        break
    }
    let parameters = [
            "to": to,
            "notification": [
                "body": titleContent,
                "title": "New",
                "sound": "default"
            ]
            ] as [String : Any]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://fcm.googleapis.com/fcm/send")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                //print(error)
            } else {
                //let httpResponse = response as? HTTPURLResponse
                //print(httpResponse)
            }
        })
        
        dataTask.resume()
    }
}



