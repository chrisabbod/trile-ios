//
//  Offenses.swift
//  Trile
//
//  Created by Chris Abbod on 1/18/20.
//  Copyright © 2020 Trile. All rights reserved.
//

//Decodable means that you can make your data type (Example: a Struct) encode/decode itself into another way of representation. For example, encode your struct “Car” into a JSON or decode a JSON response into a Car

//CaseIteratable is a protocol, introduced in Swift 4.2. It automatically synthesises a collection of all the cases in your enum in the order that is defined, however you have to provide your own allCases implementation if your enum contains associated values

//Raw Representable allows the Enums createed to convert to and from an associated raw value of type String

import Foundation

struct Offense: Decodable {
    let name: String
    let category: Category
    let offenseClass: OffenseClass
    
    enum Category: Decodable {
        case felony
        case misdemeanor
        case infraction
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
}

extension Offense.Category: CaseIterable { }

extension Offense.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "Felony": self = .felony
        case "Misdemeanor": self = .misdemeanor
        case "Infraction": self = .infraction
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .felony: return "Felony"
        case .misdemeanor: return "Misdemeanor"
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
