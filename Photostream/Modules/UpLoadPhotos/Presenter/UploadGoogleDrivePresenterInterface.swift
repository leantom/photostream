//
//  UploadGoogleDrivePresenterInterface.swift
//  Pikme
//
//  Created by Lê An on 8/22/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol UploadGoogleDrivePresenterInterface: class {
    
    var interactor: UploadGoogleDriveInteractorInput! { set get }
    var view: PostUploadViewInterface! { set get }
    var wireframe: PostUploadWireframeInterface! { set get }
    var moduleDelegate: PostUploadModuleDelegate? { set get }
    var item: PostUploadItem! { set get }
}
