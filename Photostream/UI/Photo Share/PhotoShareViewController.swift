//
//  PhotoShareViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 18/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import GPUImage

class PhotoShareViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    var safeSearchAnotation: SafeSearchAnnotation!
    var presenter: PhotoShareModuleInterface!
    var fileService: FileServiceProvider!
    var image: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let auth = AuthSession()
        fileService = FileServiceProvider(session: auth)
        imageView.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createStandardActionSheet { (reportType) in
//
//        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTapCancel(_ sender: AnyObject) {
        presenter.cancel()
        presenter.pop()
    }
    
    @IBAction func didTapDone(_ sender: AnyObject) {
        guard let message = contentTextView.text, !message.isEmpty else {
            return
        }
        
        fileService.createRequest(with: fileService.base64EncodeImage(image)) { (safeSearch) in
            if ((safeSearch?.isAdult)! || (safeSearch?.isviolence)!) {
                DispatchQueue.main.async {
                    showAlert(with: "Nội dung không phù hợp (có yếu tố bạo lực hoặc khiêu dâm)", viewController: self)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.image = self.resizeImage(image: self.image, targetSize: CGSize(width: 720, height: 1080))
                    self.presenter.finish(with: self.image, content:message)
                    self.presenter.dismiss()
                }
            }
        }
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



extension PhotoShareViewController: PhotoShareViewInterface {
    
    var controller: UIViewController? {
        return self
    }
}


