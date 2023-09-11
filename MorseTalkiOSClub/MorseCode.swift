//
//  MorseCode.swift
//  MorseTalkiOSClub
//
//  Created by Sankaet Cheemalamarri on 10/11/22.
//
import Foundation

class MorseCode : ObservableObject {
    var morseList : [CodeType] = []
    let morseDict : [String : String] = [".-": "A",
                                         "-...": "B",
                                         "-.-.": "C",
                                         "-..": "D",
                                         ".": "E",
                                         "..-.": "F",
                                         "--.": "G",
                                         "....": "H",
                                         "..": "I",
                                         ".---": "J",
                                         "-.-": "K",
                                         ".-..": "L",
                                         "--": "M",
                                         "-.": "N",
                                         "---": "O",
                                         ".--.": "P",
                                         "--.-": "Q",
                                         ".-.": "R",
                                         "...": "S",
                                         "-": "T",
                                         "..-": "U",
                                         "...-": "V",
                                         ".--": "W",
                                         "-..-": "X",
                                         "-.--": "Y",
                                         "--..": "Z",
                                         ".----": "1",
                                         "..---": "2",
                                         "...--": "3",
                                         "....-": "4",
                                         ".....": "5",
                                         "-....": "6",
                                         "--...": "7",
                                         "---..": "8",
                                         "----.": "9",
                                         "-----": "0",
                                         ]
    
    let letterDict : [String : String] = ["A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".", "F": "..-.", "G": "--.", "H": "....", "I": "..", "J": ".---", "K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---", "P": ".--.", "Q": "--.-", "R": ".-.", "S": "...", "T": "-", "U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--", "Z": "--..", "1": ".----", "2": "..---", "3": "...--", "4": "....-", "5": ".....", "6": "-....", "7": "--...", "8": "---..", "9": "----.", "0": "-----"]
    
    @Published var currString : String = "" {
        didSet { print("currString: ", currString)}
    }
    @Published var translatedString: String = "" {
        didSet { print("Translated String: ", translatedString)}
    }
    @Published var morseString = "" {
        didSet {
            print("morseString: ", morseString)}
    }

    
    func addChar(_ toAdd : String) {
        print(currString)
//        if let addList = CodeType(rawValue: toAdd) {
//            morseList.append(addList)
//        }
        if (toAdd == CodeType.charSpace.rawValue) {
            translate();
        } else if (toAdd == CodeType.wordSpace.rawValue) {
            translatedString += " "
            morseString += " "
        } else {
            currString += toAdd;
            morseString += toAdd
        }
       // print(currString)
    }
    
    func removeLastCurr() {
        if currString.count > 0 {
            currString = String(currString.prefix(currString.count - 1))
            morseString = String(morseString.prefix(morseString.count - 1))
        }
    }
    
    func removeEverything() {
        currString = ""
        morseString = ""
        translatedString = ""
    }
    
    func removeLastChar() {
        if translatedString.count > 0 {
            let charToRemove = String(translatedString.suffix(1))
            translatedString = String(translatedString.prefix(translatedString.count - 1))
            if let charMorse = letterDict[charToRemove] {
                morseString = String(morseString.prefix(morseString.count - String(charMorse).count - 1))
            } else if charToRemove == " " {
                morseString = String(morseString.prefix(morseString.count - 1))
            }
        }
    }
    
    func removeMorseSuffix(morse: String) {
        morseString = String(currString.prefix(morseString.count - morse.count))
    }
    
    func translate() {
        if let char = morseDict[currString] {
            translatedString += char
            morseString += " "
        } else {
            if morseString != "" && currString != "" {
                var splitMorseString = morseString.split(separator: " ")
                splitMorseString.removeLast()
                morseString = ""
                for val in splitMorseString {
                    morseString += val + " "
                }
            }
        }
        currString = ""


        //print(translatedString)
    }
    
    
    enum CodeType : String, CaseIterable {
        case dot = "."
        case dash = "-"
        case charSpace = "&"
        case wordSpace = " "
    }
}

