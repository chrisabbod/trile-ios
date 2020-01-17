//
//  PickerListManager.swift
//  Trile
//
//  Created by Chris Abbod on 1/17/20.
//  Copyright © 2020 Trile. All rights reserved.
//

import UIKit

class PickerListManager {
    
    static let desiredOutcomeList = [
        "Dismissal",
        "Prayer for Judgment Continued",
        "Improper Equipment",
        "Unsupervised Probation",
        "Supervised Probation",
        "Active Sentence"
    ]
    
    static let offenseList = [
        "long",
        "list",
        "of",
        "offenses"
    ]
    
    static let offenseClassList = [
        "A1",
        "1",
        "2",
        "3",
        "Infraction",
        "Misdemeanor",
        "Felony"
    ]
    
    static let dispositionList = [
        "None - Deferred/Diverted",
        "Prayer for Judgment Continued",
        "Improper Equipment",
        "Unsupervised Probation",
        "Supervised Probation",
        "Active Sentence",
        "None - Acquitted/Dismissed",
        "Other"
    ]
    
    static let judgmentAndSentencingList = [
        "Dismissal",
        "Prayer for Judgment Continued",
        "Improper Equipment",
        "Unsupervised Probation",
        "Supervised Probation",
        "Active Sentence"
    ]
    
    static let countyList = [
        "Cleveland",
        "Gaston",
        "Lincoln"
    ]
    
    static let clevelandLincolnJudgeList = [
        "Hon. Micah J. Sanderson",
        "Hon. Jeannette Reeves",
        "Hon. K. Dean Black",
        "Hon. Justin K. Brackett",
        "Hon. Larry J. Wilson",
        "Hon. Meredith Shuford"
    ]
    
    static let gastonJudgeList = [
        "Hon. Richard Abernethy",
        "Hon. Pennie Thrower",
        "Hon. John Greenlee",
        "Hon. Angela Hoyle",
        "Hon. James Jackson",
        "Hon. Craig Collins"
    ]
        
    static func hoursPickerList() -> [String] {
        let hoursArray = Array(0...99)
        let hoursStringArray = hoursArray.map { String($0) }  //Turn Int array into String array

        return hoursStringArray
    }
    
    static func minutesPickerList() -> [String] {
        let minutesArray = [0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60]
        let minutesStringArray = minutesArray.map { String($0)}  //Turn Int array into String array
        
        return minutesStringArray
    }
}
