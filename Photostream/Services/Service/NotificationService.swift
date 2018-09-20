//
//  NotificationService.swift
//  Pikme
//
//  Created by Lê An on 8/11/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import Foundation
protocol NotificationService {
    // post comment
    
    func postComment(from: User, token: String) 
    // like post
    func likePosts(from: User, token: String) 
    // post
    func post(from: User, token: String) 
    
}

struct NotificationServiceResult {
    
    var multicast_id: Double = 0
    var success: Bool = false
    var failure: Bool = true
    var canonical_ids = true
    
}

struct NotificationServiceData {
    var from: User?
    var token: String = ""
}

struct NotificationServiceError {
    
}
