//
//  String+Indexing.swift
//  MorseTalkiOSClub
//
//  Created by Tejeshwar Natarajan on 3/11/23.
//

import SwiftUI

extension StringProtocol {
    subscript(offset: Int) -> Character? {
        return (self == "") ? nil : self[index(startIndex, offsetBy: offset)]
    }
}
