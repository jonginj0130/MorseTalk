//
//  Dictionary+RawRepresentable.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 4/4/23.
//

import Foundation

extension Dictionary: RawRepresentable where Key == String, Value == String {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),  // convert from String to Data
            let result = try? JSONDecoder().decode([String:String].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),   // data is  Data type
              let result = String(data: data, encoding: .utf8) // coerce NSData to String
        else {
            return "{}"  // empty Dictionary resprenseted as String
        }
        return result
    }

}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),  // convert from String to Data
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),   // data is  Data type
              let result = String(data: data, encoding: .utf8) // coerce NSData to String
        else {
            return "[]"  // empty Dictionary resprenseted as String
        }
        return result
    }
}
