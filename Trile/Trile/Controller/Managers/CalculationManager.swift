//
//  CalculationManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/29/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import Foundation

class CalculationManager {
    
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
}

