//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/22/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    //MARK: -Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var submitLocationView: UIView!
    
    var addLocationDelegate : AddLocationDelegate?
    
    var placeHolder : NSAttributedString {
        get {
            return NSAttributedString(string: "Enter Your Location Here", attributes: Utilities.TextFieldPlaceHolderAttr)
        }
    }
    
    
    //MARK: -Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        setupButton(findBtn)
    }
    
    //MARK: -IBActions
    @IBAction func findOnTheMap(sender: AnyObject) {
        guard let query = locationTextField.text where query != "" else {
            showAlertViewWith("Oops!", error: "Location can't be blank.", type: .AlertViewWithOneButton , firstButtonTitle: "OK", firstButtonHandler: nil, secondButtonTitle: nil, secondButtonHandler: nil)
            return
        }

        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            guard (error == nil) else {
                print(error?.domain)
                showAlertViewWith("Oops!", error: "Search for location returns an error: \(error?.domain)", type: .AlertViewWithOneButton, firstButtonTitle: "OK", firstButtonHandler: nil, secondButtonTitle: nil, secondButtonHandler: nil)
                return
            }
            
            guard let response = response else {
                showAlertViewWith("Oops!", error: "Location didn't find.", type: .AlertViewWithOneButton, firstButtonTitle: "OK", firstButtonHandler: nil, secondButtonTitle: nil, secondButtonHandler: nil)
                return
            }
            
            if response.mapItems.count > 1 {
                showAlertViewWith("Oops!", error: "Your result contains more than one location. Please be more specific and try again.", type: .AlertViewWithOneButton, firstButtonTitle: "OK", firstButtonHandler: nil, secondButtonTitle: nil, secondButtonHandler: nil)
            }
            if let delegate = self.addLocationDelegate {
                delegate.locationFound(response, fromString: query)
            }
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(locationTextField)
    }
}


    //MARK: -UITextFieldDelegate
extension AddLocationViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.attributedText = placeHolder
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: -UI related methods
extension AddLocationViewController {

    private func setUIEnabled(enabled: Bool) {
        findBtn.enabled = enabled
        locationTextField.enabled = enabled
    }
    
    private func setupTextField() {
        locationTextField.delegate = self
        locationTextField.attributedText = placeHolder
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
}

// MARK: -Add Location Protocol
protocol AddLocationDelegate {
    func locationFound(result: MKLocalSearchResponse, fromString: String)
}
