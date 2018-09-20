//
//  UploadGoogleDriveInteractorOutput.swift
//  Pikme
//
//  Created by Lê An on 8/22/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol UploadGoogleDriveInteractorOutput: class {
    
    func didSucceed(with post: UploadedPost)
    func didFail(with message: String)
    func didUpdate(with progress: Progress)
}
