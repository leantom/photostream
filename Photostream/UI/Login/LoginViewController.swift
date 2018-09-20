//
//  LoginViewController.swift
//  Photostream
//
//  Created by Mounir Ybanez on 13/08/2016.
//  Copyright © 2016 Mounir Ybanez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseInstanceID
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBInspectable var topColor: UIColor!
    @IBInspectable var bottomColor: UIColor!
    @IBInspectable var cornerRadius: CGFloat = 0
    
    var presenter: LoginModuleInterface!
    var presenterRegistration: RegistrationModuleInterface!
    deinit {
        presenter = nil
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            // ...
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if result != nil {
                
                let id = result?.user.uid
                let userInfo = ["firstname": result?.user.displayName,
                                "lastname":  result?.user.displayName,
                                "id": id ,
                                "email": result?.user.email,
                                "photoUrl":result?.user.photoURL?.description,
                                "deviceToken":InstanceID.instanceID().token()
                ]
                
                let ref = Database.database().reference()
                let path = "users/\(id?.description ?? "")"
                ref.child(path).setValue(userInfo)
                let deviceInfo = ["id":InstanceID.instanceID().token(),
                                  "uid":id,
                                  "deviceToken":InstanceID.instanceID().token()]
                let path1 = "device-Token/\(InstanceID.instanceID().token()?.description ?? "")"
                ref.child(path1).setValue(deviceInfo)
                self.presenter.presentHome()
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
       // applyGradientBackground()
        //applyCornerRadius()
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func didTapRegister() {
        presenter.presentRegistration()
    }

    fileprivate func addIndicatorView() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.startAnimating()
        indicator.tag = 9000
        loginButton.addSubviewAtCenter(indicator)
    }

    fileprivate func removeIndicatorView() {
        loginButton.viewWithTag(9000)?.removeFromSuperview()
    }

    fileprivate func applyCornerRadius() {
        emailTextField.cornerRadius = cornerRadius
        passwordTextField.cornerRadius = cornerRadius
        loginButton.cornerRadius = cornerRadius
    }

    fileprivate func applyGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = view.frame
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func actionLoginGmail(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        // connect facebook
        let loginmanagerFB = FBSDKLoginManager()
        loginmanagerFB.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (loginResult, err) in
            if err != nil {
                let alert = UIAlertController(title: "Alert", message: err?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                if (loginResult?.isCancelled)! {
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, err) in
                    if result != nil {
                        
                        let id = result?.user.uid
                        let userInfo = ["firstname": result?.user.displayName,
                                        "lastname":  result?.user.displayName,
                                        "id": id ,
                                        "email": result?.user.email,
                                        "photoUrl":result?.user.photoURL?.description,
                                        "deviceToken":InstanceID.instanceID().token()
                                        ]
                        
                        let ref = Database.database().reference()
                        let path = "users/\(id?.description ?? "")"
                        ref.child(path).setValue(userInfo)
                        let deviceInfo = ["id":InstanceID.instanceID().token(),
                                          "uid":id,
                                          "deviceToken":InstanceID.instanceID().token()]
                        let path1 = "device-Token/\(InstanceID.instanceID().token()?.description ?? "")"
                        ref.child(path1).setValue(deviceInfo)
                        self.presenter.presentHome()
                    } else {
                        let alert = UIAlertController(title: "Alert", message: err?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            }))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
            
        }
    }
}

extension LoginViewController: LoginViewInterface {
    
    weak internal var controller: UIViewController? {
        return self
    }
    
    
    
    @IBAction func didTapLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty else {
            return
        }
        
        view.endEditing(false)
        
        loginButton.setTitle("", for: UIControlState())
        view.isUserInteractionEnabled = false
        addIndicatorView()

        presenter.login(email: email, password: password)
    }
    
    func didReceiveError(message: String) {
   //     loginButton.setTitle("Login", for: UIControlState())
        view.isUserInteractionEnabled = true
        removeIndicatorView()
        
        presenter.presentErrorAlert(message: message)
    }
    
    func didLoginOk() {
        presenter.presentHome()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            didTapLogin()
        }
        return false
    }
}
