//
//  LoginViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/19/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var keyboardOnScreen = false

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
            debugTextLabel.text = "Email or Password Empty."
        } else {
            setUIEnabled(false)
            postSession()
        }
        
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
        
        let parameters = [String: AnyObject]()
        let method = UDClient.Methods.Session
        let jsonBody = "{\"udacity\": {\"username\": \"\(loginEmailTextField.text!)\", \"password\": \"\(loginPasswordTextField.text!)\"}}"
        
        UDClient.sharedInstance().taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (result, error) in
            performUIUpdatesOnMain({ 
                guard (error == nil) else {
                    self.displayError("Login Failed. Please try again. (Error: \(error!.domain)")
                    return
                }
               
                guard let session = result[UDClient.ResponseKeys.Session] as? [String: AnyObject] else {
                    self.displayError("Login Failed. (Get session).")
                    return
                }
                
                guard let sessionId = session[UDClient.ResponseKeys.SessionId] as? String else {
                    self.displayError("Login Failed. (Get session id).")
                    return
                }
                
                UDClient.sharedInstance().sessionID = sessionId
                self.completeLogin()
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
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
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



