//
//  Offenses.swift
//  Trile
//
//  Created by Chris Abbod on 1/18/20.
//  Copyright © 2020 Trile. All rights reserved.
//

//Decodable means that you can make your data type (Example: a Struct) encode/decode itself into another way of representation. For example, encode your struct “Car” into a JSON or decode a JSON response into a Car

//CaseIteratable is a protocol, introduced in Swift 4.2. It automatically synthesises a collection of all the cases in your enum in the order that is defined, however you have to provide your own allCases implementation if your enum contains associated values
//Since Offense.Category conforms to CaseIterable, the compiler can automatically synthesize allCases for any RawRepresentable enumeration, adding the titles that match the categories you assigned to any offense objects to the scope bar

//Raw Representable allows the Enums createed to convert to and from an associated raw value of type String

import Foundation

struct Offense: Decodable {
    let name: String
    let category: Category
    let offenseClass: OffenseClass
    let trafficType: Traffic
    
    enum Category: Decodable {
        case all
        case none
        case infraction
        case misdemeanor
        case misdemeanorProbation
        case felony
    }
    
    enum OffenseClass: Decodable {
        case A1
        case One
        case Two
        case Three
        case A
        case B1
        case B2
        case C
        case D
        case E
        case F
        case G
        case H
        case I
        case none
    }
    
    enum Traffic: Decodable {
        case traffic
        case nonTraffic
    }
}

extension Offense.Category: CaseIterable { }

extension Offense.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "All": self = .all
        case "None": self = .none
        case "Felony": self = .felony
        case "Misdemeanor": self = .misdemeanor
        case "Probation": self = .misdemeanorProbation
        case "Infraction": self = .infraction
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .all: return "All"
        case .none: return "None"
        case .felony: return "Felony"
        case .misdemeanor: return "Misdemeanor"
        case .misdemeanorProbation: return "Probation"
        case .infraction: return "Infraction"
        }
    }
}

extension Offense.OffenseClass: CaseIterable { }

extension Offense.OffenseClass: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "A1": self = .A1
        case "One": self = .One
        case "Two": self = .Two
        case "Three": self = .Three
        case "A": self = .A
        case "B1": self = .B1
        case "B2": self = .B2
        case "C": self = .C
        case "D": self = .D
        case "E": self = .E
        case "F": self = .F
        case "G": self = .G
        case "H": self = .H
        case "I": self = .I
        case "none": self = .none
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .A1: return "A1"
        case .One: return "One"
        case .Two: return "Two"
        case .Three: return "Three"
        case .A: return "A"
        case .B1: return "B1"
        case .B2: return "B2"
        case .C: return "C"
        case .D: return "D"
        case .E: return "E"
        case .F: return "F"
        case .G: return "G"
        case .H: return "H"
        case .I: return "I"
        case .none: return "none"
        }
    }
}

extension Offense.Traffic: CaseIterable { }

extension Offense.Traffic: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "Traffic": self = .traffic
        case "Non Traffic": self = .nonTraffic
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .traffic: return "Traffic"
        case .nonTraffic: return "Non Traffic"
        }
    }
}

extension Offense {
    static func offenses() -> [Offense] {
        guard
            let url = Bundle.main.url(forResource: "offenses", withExtension: "json"),
            let data = try? Data(contentsOf: url)
            else {
                return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Offense].self, from: data)
        } catch {
            return []
        }
    }
}
