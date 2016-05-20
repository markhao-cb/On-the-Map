//
//  PaddingTextField.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/19/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {

    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x + paddingLeft, bounds.origin.y,
                          bounds.size.width - paddingLeft - paddingRight, bounds.size.height);
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }

}
