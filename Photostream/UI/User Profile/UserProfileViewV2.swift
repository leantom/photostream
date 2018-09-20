//
//  UserProfileViewV2.swift
//  Pikme
//
//  Created by Lê An on 8/16/18.
//  Copyright © 2018 Mounir Ybanez. All rights reserved.
//

import UIKit
//
//protocol UserProfileViewV2Delegate: class {
//
//    func willFollow(view: UserProfileViewV2)
//    func willUnfollow(view: UserProfileViewV2)
//    func willEdit(view: UserProfileViewV2)
//    func willShowFollowing()
//    func willShowFollowers()
//}


class UserProfileViewV2: UIView {
    let nibName = "UserProfileViewV2"
    weak var delegate: UserProfileViewDelegate?
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var lblNumberFollowers: UILabel!
    
    @IBOutlet weak var lblNumberFollowing: UILabel!
    var isMe = true
    
    @IBAction func actionEditAvatar(_ sender: Any) {
        delegate?.willEdit(view: self)
    }
    @IBOutlet weak var lblNumberPosts: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnFollow: UIButton!

    @IBAction func actionFollowing(_ sender: Any) {
        delegate?.willShowFollowing()
    }
    
    @IBAction func actionFollower(_ sender: Any) {
        delegate?.willShowFollowers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
           loadViewFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
           loadViewFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
     
    }
    
    var contentView: UIView!

    func loadViewFromNib() {
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as! UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }
    

}
