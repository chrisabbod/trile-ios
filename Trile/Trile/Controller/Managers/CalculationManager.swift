//
//  CalculationManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/29/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import Foundation

class CalculationManager {
    
    static func calculatedTotalTimeClaimed(_ fileNumber: FileNumber) -> [String: Int] {
        
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
        
        return ["total_hours": totalHours, "total_minutes": totalMinutes]
    }
    
    static func calculateTotalExpenses(_ fileNumber: FileNumber) -> String {
        let travel = (fileNumber.travel as NSString).integerValue
        let copying = (fileNumber.copying as NSString).integerValue
        let other = (fileNumber.other as NSString).integerValue

        let totalFees = travel + copying + other
        return String(totalFees)
    }
}
