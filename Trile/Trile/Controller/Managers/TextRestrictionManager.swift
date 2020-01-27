//
//  TextRestrictionManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/16/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class TextRestrictionManager {
    
    static func restrictTextLength(by amount: Int, _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= amount
    }
    
    static func restrictTextLengthAndCharacters(by amount : Int, _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Only allow type Integer to be entered in TextFields and limit to number passed in
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.components(separatedBy: inverseSet)
        
        // Rejoin these components
        
        let filtered = components.joined(separator: "")
        
        //Limit characters
        let maxLength = amount
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered && newString.length <= maxLength
    }
    
    static func restrictTextLengthAndNumbers(by amount : Int, _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Only allow type Integer to be entered in TextFields and limit to number passed in
        
        // Create an `NSCharacterSet` set which includes everything *but* the digits
        
        let inverseSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        
        // At every character in this "inverseSet" contained in the string,
        // split the string up into components which exclude the characters
        // in this inverse set
        let components = string.components(separatedBy: inverseSet)
        
        // Rejoin these components
        
        let filtered = components.joined(separator: "")
        
        //Limit characters
        let maxLength = amount
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        // If the original string is equal to the filtered string, i.e. if no
        // inverse characters were present to be eliminated, the input is valid
        // and the statement returns true; else it returns false
        return string == filtered && newString.length <= maxLength
    }
}
