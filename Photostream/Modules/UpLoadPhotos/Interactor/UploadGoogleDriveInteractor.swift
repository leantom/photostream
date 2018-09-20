//
//  UploadGoogleDriveInteractor.swift
//  Pikme
//
//  Created by Lê An on 8/22/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import Foundation

class UploadGoogleDriveInteractor: UploadGoogleDriveInteractorInterface {
    var output: UploadGoogleDriveInteractorOutput?
    var fileService: FileService!
    var postService: PostService!
    
    required init(fileService: FileService, postService: PostService) {
        self.fileService = fileService
        self.postService = postService
    }
}


