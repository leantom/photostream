//
//  UploadGoogleDriveInteractorInput.swift
//  Pikme
//
//  Created by Lê An on 8/22/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import Foundation
protocol UploadGoogleDriveInteractorInput: class {
    
    func upload(with datas: [FileServiceImageUploadData], contents: [String])
}
