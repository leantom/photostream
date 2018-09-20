//
//  UIView+Extensions.swift
//  Photostream
//
//  Created by Mounir Ybanez on 15/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import Sheeeeeeeeet

enum ReportType: String {
    case Report = "Report"
    case Mute = "Mute"
    case Unfollow = "Unfollow"
}

func createStandardActionSheet(callback:@escaping (ReportType)->Void) -> ActionSheet {
    
    let title = ActionSheetTitle(title: "Select an option")
    let item1 = ActionSheetItem(title: "Report", value: 1, image: nil)
    let item2 = ActionSheetItem(title: "Mute", value: 2, image: nil)
    let item3 = ActionSheetItem(title: "Unfollow", value: 3, image: nil)
    let button = ActionSheetOkButton(title: "OK")
    let items = [title,item1,item2,item3,button]
    
    return ActionSheet(items: items) { _, item in
        guard let value = item.value as? Int else { return }
        if value == 1 {
            callback(ReportType(rawValue: ReportType.Report.rawValue)!)
        }
        if value == 2 {
            callback(ReportType(rawValue: ReportType.Report.rawValue)!)
        }
        if value == 3 {
            callback(ReportType(rawValue: ReportType.Report.rawValue)!)
        }
    }
}

func showAlert(with content: String, viewController: UIViewController) {
    let alert = UIAlertController(title: "Alert", message: content, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        
    }))
    viewController.present(alert, animated: true, completion: nil)
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
}

extension UIView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
}

extension UIView {

    var width: CGFloat {
        get {
            return frame.size.width
        }
    }

    var height: CGFloat {
        get {
            return frame.size.height
        }
    }

    var posX: CGFloat {
        get {
            return frame.origin.x
        }
    }

    var posY: CGFloat {
        get {
            return frame.origin.y
        }
    }
}

extension UIView {

    func addSubviewAtCenter(_ subview: UIView!) {
        let centerX = (width - subview.width) / 2
        let centerY = (height - subview.height) / 2
        let centerFrame = CGRect(x: centerX, y: centerY, width: subview.width, height: subview.height)
        subview.frame = centerFrame
        addSubview(subview)
    }
}

extension UIView {

    func createImage() -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

extension UIView {
    
    func removeAllSubviews() {
        subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
}
