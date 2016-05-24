//
//  LoginViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/19/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    var keyboardOnScreen = false

    //MARK: Properties
    @IBOutlet weak var loginEmailTextField: PaddingTextField!
    @IBOutlet weak var loginPasswordTextField: PaddingTextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var udImageView: UIImageView!
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        
        if let FBtoken = FBSDKAccessToken.currentAccessToken() {
            UDClient.sharedInstance().FBToken = FBtoken.tokenString
            setUIEnabled(false)
            postSessionWithFBToken()
        }
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

    //MARK: -IBAction Methods
    @IBAction func loginPressed(sender: AnyObject) {
        
        userDidTapView(self)
        
        if loginEmailTextField.text!.isEmpty || loginPasswordTextField.text!.isEmpty {
            displayError("Email and Password Could not be blank.")
        } else if !Utilities.Reachability.isConnectedToNetwork() {
            displayError("The Internet Connection Appears to be Offline.")
        } else {
            setUIEnabled(false)
            postSessionWithUsernameAndPassword()
        }
        
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        openUrlFrom(UDClient.Constants.SignUpURL)
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(loginEmailTextField)
        resignIfFirstResponder(loginPasswordTextField)
    }
    
    @IBAction func fbLoginPressed(sender: AnyObject) {
        if !Utilities.Reachability.isConnectedToNetwork() {
            displayError("The Internet Connection Appears to be Offline.")
        } else {
            setUIEnabled(false)
        }
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
            udImageView.hidden = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
            udImageView.hidden = false
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
}

//MARK: -Networking Methods
extension LoginViewController {
    private func postSessionWithUsernameAndPassword() {
        UDClient.sharedInstance().authenticateWithUsernameAndPasswordOrFBToken(loginEmailTextField.text!, password: loginPasswordTextField.text!, token: nil) { (success, errorString) in
            
            performUIUpdatesOnMain({ 
                if success {
                    self.completeLogin()
                } else {
                    print(errorString)
                    self.displayError("Invalid Email or Password.")
                }
            })
        }
    }
    
    private func postSessionWithFBToken() {
        UDClient.sharedInstance().authenticateWithUsernameAndPasswordOrFBToken(nil, password: nil, token: UDClient.sharedInstance().FBToken!) { (success, errorString) in
            
            performUIUpdatesOnMain({ 
                if success {
                    self.completeLogin()
                } else {
                    print(errorString)
                    FBSDKLoginManager().logOut()
                    self.displayError("Could Not Login with Facebook.")
                }
            })
        }
    }
}

// MARK: -FBSDK Login Button Delegate
extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        performUIUpdatesOnMain { 
            guard error == nil else {
                self.displayError(error.localizedDescription)
                return
            }
            
            if result.isCancelled {
                self.displayError("Authenticate with Facebook Failed.")
            } else {
                print("Authenticate with Facebook complete.")
                UDClient.sharedInstance().FBToken = result.token.tokenString
                self.postSessionWithFBToken()
            }
            
        }
    }
}

// MARK: -UI related methods
extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        signUpButton.enabled = enabled
        loginEmailTextField.enabled = enabled
        loginPasswordTextField.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            NVActivityIndicatorView.hideHUDForView(view)
        } else {
            loginButton.alpha = 0.5
            NVActivityIndicatorView.showHUDAddedTo(view)
        }
        
        
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            showAlertViewWith("Oops!", error: errorString, type: .AlertViewWithOneButton, firstButtonTitle: "OK", firstButtonHandler: nil, secondButtonTitle: nil, secondButtonHandler: nil)
            setUIEnabled(true)
        }
    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}

//MARK: Notification methods
extension LoginViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}



