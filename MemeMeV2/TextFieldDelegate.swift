//
//  TextFieldDelegate.swift
//  MemeMeV1
//
//  Created by Yu-Jen Chang on 6/30/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    // clear default text when user tap textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
