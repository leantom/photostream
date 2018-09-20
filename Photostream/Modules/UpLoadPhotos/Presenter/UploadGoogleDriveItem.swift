//
//  UploadGoogleDriveItem.swift
//  Pikme
//
//  Created by Lê An on 8/22/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import Foundation
import UIKit

struct UploadGoogleDriveItem {
    
    var image: UIImage!
    var content: String!
    
    var imageData: FileServiceImageUploadData {
        var data = FileServiceImageUploadData()
        data.data = UIImageJPEGRepresentation(image, 1.0)
        data.width = Float(image.size.width)
        data.height = Float(image.size.height)
        return data
    }
}
