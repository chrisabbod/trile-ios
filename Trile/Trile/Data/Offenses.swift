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

struct Offenses: Decodable {
    let offense: String
    let category: Category
    
    enum Category: Decodable {
        case all
        case felony
        case misdemeanor
        case infraction
    }
}

extension Offenses.Category: CaseIterable { }

extension Offenses.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "All": self = .all
        case "Felony": self = .felony
        case "Misdemeanor": self = .misdemeanor
        case "Infraction": self = .infraction
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .all: return "All"
        case .felony: reutn "Felony"
        case .misdemeanor: return "Misdemeanor"
        case .infraction: return "Infraction"
        case .other: return "Other"
        }
    }
}

extension Offenses {
    static func offenses() -> [Offenses] {
        guard
            let url = Bundle.main.url(forResource: "offenses", withExtension: "json"),
            let data = try? Data(contentsOf: url)
            else {
                return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Offenses].self, from: data)
        } catch {
            return []
        }
    }
}
