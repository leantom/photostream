//
//  UserProfileViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 10/12/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var userProfileView: UserProfileView!
    var userProfileViewV2: UserProfileViewV2!
    var presenter: UserProfileModuleInterface!
   
    override func loadView() {
        let frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        userProfileView = UserProfileView()
//        userProfileView.frame = frame
//        userProfileView.delegate = self
        userProfileViewV2 = UserProfileViewV2()
        userProfileViewV2.frame = frame
        userProfileViewV2.frame.size.height = 271
        view = userProfileView
        userProfileViewV2.delegate = self
        view.addSubview(userProfileViewV2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileView.actionLoadingView.startAnimating()
        presenter.fetchUserProfile()
    }
    
    func startLoadingView() {
        userProfileView.actionLoadingView.startAnimating()
    }
    
    func stopLoadingView() {
        userProfileView.actionLoadingView.stopAnimating()
    }
}

extension UserProfileViewController: UserProfileScene {
    
    var controller: UIViewController? {
        return self
    }
    
    func didFetchUserProfile(with data: UserProfileData) {
        update(with: data)
    }
    
    func didFollow(with data: UserProfileData) {
        update(with: data)
    }
    
    func didUnfollow(with data: UserProfileData) {
        update(with: data)
    }
    
    func didFetchUserProfile(with error: String?) {
        stopLoadingView()
    }
    
    func didFollow(with error: String) {
        stopLoadingView()
    }
    
    func didUnfollow(with error: String) {
        stopLoadingView()
    }
    
    private func update(with data: UserProfileData) {
        let item = data as? UserProfileViewItem
        userProfileView.configure(wiht: item)
        userProfileViewV2.configure(wiht: item)
        stopLoadingView()
    }
}

extension UserProfileViewController: UserProfileViewDelegate {
    func willFollow(view: UserProfileViewV2) {
        startLoadingView()
        presenter.follow()
    }
    
    func willUnfollow(view: UserProfileViewV2) {
        startLoadingView()
        presenter.unfollow()
    }
    
    func willEdit(view: UserProfileViewV2) {
        presenter.presentProfileEdit()
    }
    
    
    func willEdit(view: UserProfileView) {
        presenter.presentProfileEdit()
    }
    
    func willFollow(view: UserProfileView) {
        startLoadingView()
        presenter.follow()
    }
    
    func willUnfollow(view: UserProfileView) {
        startLoadingView()
        presenter.unfollow()
    }
    
    func willShowFollowers() {
        presenter.presentFollowers()
    }
    
    func willShowFollowing() {
        presenter.presentFollowing()
    }
}
