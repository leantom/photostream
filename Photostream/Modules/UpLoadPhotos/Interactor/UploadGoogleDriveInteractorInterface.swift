//
//  UploadGoogleDriveInteractorInterface.swift
//  Pikme
//
//  Created by Lê An on 8/22/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import Foundation
protocol UploadGoogleDriveInteractorInterface: class {
    
    var output: UploadGoogleDriveInteractorOutput? { set get }
    var fileService: FileService! { set get }
    var postService: PostService! { set get }
    
    init(fileService: FileService, postService: PostService)
}
