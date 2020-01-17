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
    
    static let highestEducationList = [
        "Didn't Finish Highschool",
        "Highschool Graduate",
        "Some College",
        "College Graduate",
        "Some Graduate Work",
        "Graduate Degree",
    ]
    
    static let areaOfStudyList = ["Accounting", "Biology", "Chemistry", "Computer Science", "Engineering", "English", "Geography", "Geology", "Gender Studies", "History", "Journalism", "Law", "Mathematics", "Medical", "Nursing", "Philosophy", "Political Science", "Religion", "Social Work", "Teaching"]
    
    static let statesList = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    static let incomeRangeList = ["No Income", "< 10k Per Year", "10k - 19k Per Year", "20k - 39k Per Year", "40k - 79k Per Year", "> 80K Per Year"]
}
