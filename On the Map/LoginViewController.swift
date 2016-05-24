//
//  LoginViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/19/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    var keyboardOnScreen = false
//    let fbLoginButton: FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        return button
//    }()

    //MARK: Properties
    @IBOutlet weak var loginEmailTextField: PaddingTextField!
    @IBOutlet weak var loginPasswordTextField: PaddingTextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var udImageView: UIImageView!
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

    @IBAction func loginPressed(sender: AnyObject) {
        
        userDidTapView(self)
        
        if loginEmailTextField.text!.isEmpty || loginPasswordTextField.text!.isEmpty {
            displayError("Email and Password Could not be blank.")
        } else if !Utilities.Reachability.isConnectedToNetwork() {
            displayError("The Internet Connection Appears to be Offline.")
        } else {
            setUIEnabled(false)
            postSession()
        }
        
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        openUrlFrom(UDClient.Constants.SignUpURL)
    }
    
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugTextLabel.text = ""
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
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
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(loginEmailTextField)
        resignIfFirstResponder(loginPasswordTextField)
    }
}

extension LoginViewController {
    private func postSession() {
        UDClient.sharedInstance().authenticateWithUsernameAndPassword(loginEmailTextField.text!, password: loginPasswordTextField.text!) { (success, errorString) in
            
            performUIUpdatesOnMain({ 
                if success {
                    self.completeLogin()
                } else {
                    self.displayError("Invalid Email or Password.")
                }
            })
        }
        
    }
}

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        loginButton.enabled = enabled
        debugTextLabel.enabled = enabled
        signUpButton.enabled = enabled
        loginEmailTextField.enabled = enabled
        loginPasswordTextField.enabled = enabled
//        showProgressIndicator(self.view, animated: !enabled)
        
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
}

extension LoginViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}



