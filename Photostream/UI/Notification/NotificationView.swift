//
//  Notification.swift
//  Pikme
//
//  Created by Lê An on 8/18/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        
    }
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    let nibName = "NotificationView"
    func loadViewFromNib() {
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as! UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }

}
