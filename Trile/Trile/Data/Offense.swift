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
    
    enum Category: Decodable {
        case all
        case felony
        case misdemeanor
        case infraction
        case other
    }
}

extension Offense.Category: CaseIterable { }

extension Offense.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "All": self = .all
        case "Felony": self = .felony
        case "Misdemeanor": self = .misdemeanor
        case "Infraction": self = .infraction
        case "Other": self = .other
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .all: return "All"
        case .felony: return "Felony"
        case .misdemeanor: return "Misdemeanor"
        case .infraction: return "Infraction"
        case .other: return "Other"
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
