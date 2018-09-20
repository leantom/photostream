//
//  LoginModuleInterface.swift
//  Photostream
//
//  Created by Mounir Ybanez on 02/11/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import Foundation

protocol LoginModuleInterface: class {
    func loginWithFacebook(email: String, password: String, firstName: String, lastName: String)
    func login(email: String, password: String)
    func presentErrorAlert(message: String)
}
