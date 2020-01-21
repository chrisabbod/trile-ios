//
//  FileNumber.swift
//  Trile
//
//  Created by Chris Abbod on 12/31/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import Foundation

class FileNumber {
    var documentID: String = "" //ID given to document generated by firestore database
    
    var imageData: Data = Data()
    var imagePath: String = ""
    
    var assignedFileNumber: String = ""
    var bond: String = "0"
    var continuances: String = "0"
    var desiredOutcome: String = ""
    var offense: String = ""
    var offenseCategory: String = ""
    var offenseClass: String = ""
    var disposition: String = ""
    var judgmentAndSentencing: String = ""
    var county: String = ""
    var nameOfJudgeSettingFee: String = ""
    
    var dateAppointed: String = ""  //The date the lawyer gets an email assigning them to a case
    var dateOfFirstClientInterview: String = "" //The date the lawyer first meets their client, generally in court
    var dateOfFinalDisposition: String = "" //The date a verdict is rendered on the case
    
    var timeInCourtHours: Int = 0
    var timeInCourtMinutes: Int = 0
    var timeInCourtWaitingHours: Int = 0
    var timeInCourtWaitingMinutes: Int = 0
    var timeOutOfCourtHours: Int = 0
    var timeOutOfCourtMinutes: Int = 0
    
    var pdfData: Data = Data()
}
