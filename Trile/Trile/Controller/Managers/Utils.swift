//
//  Utils.swift
//  Trile
//
//  Created by Chris Abbod on 2/16/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class Utils {
    
    //MARK: Format Date
    
    static func getCurrentDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    static func getCurrentDateAndTime() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    static func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    static func formatStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.locale = Locale.current
        let formattedDate = dateFormatter.date(from: dateString)
        
        return formattedDate!
    }
    
    //MARK: Format Time
    
    static func formatTimeInCourt(_ fileNumber: FileNumber) -> String {
        let courtHours = (fileNumber.timeInCourtHours as NSString).integerValue
        let courtMinutes = (fileNumber.timeInCourtMinutes as NSString).integerValue
        
        let minutesDecimalConversion: Double = Double(courtMinutes) / 60
        let hoursAndMinutes = Double(courtHours) + minutesDecimalConversion
        
        let formattedTime = String(format: "%.1f", hoursAndMinutes)
        
        return formattedTime
    }
    
    static func formatTimeInCourtWaiting(_ fileNumber: FileNumber) -> String {
        let courtWaitingHours = (fileNumber.timeInCourtWaitingHours as NSString).integerValue
        let courtWaitingMinutes = (fileNumber.timeInCourtWaitingMinutes as NSString).integerValue

        let minutesDecimalConversion: Double = Double(courtWaitingMinutes) / 60
        let hoursAndMinutes = Double(courtWaitingHours) + minutesDecimalConversion
        
        let formattedTime = String(format: "%.1f", hoursAndMinutes)
        
        return formattedTime
    }
    
    static func formatTimeOutOfCourt(_ fileNumber: FileNumber) -> String {
        let outOfCourtHours = (fileNumber.timeOutOfCourtHours as NSString).integerValue
        let outOfCourtMinutes = (fileNumber.timeOutOfCourtMinutes as NSString).integerValue

        let minutesDecimalConversion: Double = Double(outOfCourtMinutes) / 60
        let hoursAndMinutes = Double(outOfCourtHours) + minutesDecimalConversion
        
        let formattedTime = String(format: "%.1f", hoursAndMinutes)
        
        return formattedTime
    }
    
    static func calculateTotalTimeClaimed(_ fileNumber: FileNumber) -> String {
        
        let courtHours = (fileNumber.timeInCourtHours as NSString).integerValue
        let courtWaitingHours = (fileNumber.timeInCourtWaitingHours as NSString).integerValue
        let outOfCourtHours = (fileNumber.timeOutOfCourtHours as NSString).integerValue
        var totalHours = courtHours + courtWaitingHours + outOfCourtHours
        
        let courtMinutes = (fileNumber.timeInCourtMinutes as NSString).integerValue
        let courtWaitingMinutes = (fileNumber.timeInCourtWaitingMinutes as NSString).integerValue
        let outOfCourtMinutes = (fileNumber.timeOutOfCourtMinutes as NSString).integerValue
        var totalMinutes = courtMinutes + courtWaitingMinutes + outOfCourtMinutes
        
        let hoursFromMinutes = totalMinutes / 60
        let remainingMinutes = totalMinutes % 60
        
        totalHours = totalHours + hoursFromMinutes
        totalMinutes = remainingMinutes
        
        let decimalConversion: Double = Double(remainingMinutes) / 60
        let convertedTime = Double(totalHours) + decimalConversion
        
        let totalTime = String(format: "%.1f", convertedTime)
        
        return totalTime
    }
    
    static func calculateTotalExpenses(_ fileNumber: FileNumber) -> String {
        let travel = (fileNumber.travel as NSString).integerValue
        let copying = (fileNumber.copying as NSString).integerValue
        let other = (fileNumber.other as NSString).integerValue

        let totalFees = travel + copying + other
        return String(totalFees)
    }
    
    //MARK: Text Restriction
    
    static func restrictTextLength(by amount: Int, _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= amount
    }
    
    //MARK: Format Name
    
    static func formatFullName(firstName first: String, lastName last: String) -> String {
        return first + " " + last
    }
    
    static func formatFullName(firstName first: String, middleName middle: String, lastname last: String) -> String {
        return first + " " + middle + " " + last
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
