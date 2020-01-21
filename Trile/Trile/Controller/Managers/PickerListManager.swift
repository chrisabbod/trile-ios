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
    
    static let offenseCategoryList = [
        "Infraction",
        "Misdemeanor",
        "Felony"
    ]
    
    static let offenseClassList = [
        "None",
        "A1",
        "1",
        "2",
        "3",
        "A",
        "B1",
        "B2",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "I"
    ]

    static let dispositionList = [
        "Guilty Plea Before Trial: Most Serious Original Charge",
        "Guilty Plea Before Trial: Other Offense",
        "Guilty Plea During Trial: Other Offense",
        "Trial: Guilty Most Serious Original Charge",
        "Trial: Guilty Other Offense",
        "Trial: Acquitted",
        "Probation Violation Found",
        "Dismissed With Leave",
        "Dismissed Without Leave",
        "FTA/OFA Without Dismissal",
        "Deferred/Diverted",
        "Held In Criminal Contempt",
        "No Probable Cause",
        "Attorney Withdrew",
        "None (Interim Fee)",
        "Other"
    ]
    
    static let judgmentAndSentencingList = [
        "Active Sentence",
        "Split Sentence",
        "Supervised Probation",
        "Unsupervised Probation",
        "Probation Terminated",
        "PJC",
        "Fines and Costs Only",
        "None (Acquitted/Dismissed)",
        "None (Deferred/Diverted)",
        "None (Attorney Withdrew)",
        "None (Interim Fee)",
        "Other"
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
