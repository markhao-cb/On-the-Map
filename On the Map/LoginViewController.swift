//
//  LoginViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/19/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var loginEmailTextField: PaddingTextField!
    @IBOutlet weak var loginPasswordTextField: PaddingTextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
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
        }
    }
}

