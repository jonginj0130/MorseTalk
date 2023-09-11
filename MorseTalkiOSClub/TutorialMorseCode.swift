//
//  TutorialMorseCode.swift
//  MorseTalkiOSClub
//
//  Created by Jongin Jun on 3/9/23.
//

import SwiftUI

class TutorialMorseCode : ObservableObject {
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
    
    let sample = ["DOT", "DASH", "MORSE", "CODE", "TALK", "APP", "IOS", "CLUB", "APPLE", "DEMO"]

        
    @Published var letterPointer = 0
    @Published var wordToGuess = ""
    
    var currentChar: Character {
        wordToGuess[letterPointer] ?? "0"
    }
    
    var currentCharMorse: String {
        translateToMorse(currentChar)
    }
    
    init() {
        reset()
    }
    
    func reset() {
        var newWord = sample.randomElement()!
        
        while newWord == wordToGuess {
            newWord = sample.randomElement()!
        }
        
        wordToGuess = newWord
        letterPointer = 0
    }
    
    func checkNewMorse(_ newMorse: String) -> Bool {
        // returns whether the new morse is correct
        let index = wordToGuess.index(wordToGuess.startIndex, offsetBy: letterPointer)
        let letterMorse = translateToMorse(wordToGuess[index])
        return letterMorse.hasPrefix(newMorse)
    }
    
    func userDidUpdateWord(_ newWord: String, completion: (() -> ())? = nil) -> Bool {
        if !wordToGuess.hasPrefix(newWord) {
            if newWord != "" {
                letterPointer -= 1
                if letterPointer < 0 { letterPointer = 0 }
            }
            return false
        }
        
        if letterPointer <= (wordToGuess.count - 1) {
            // End of current word, so generate new word
            if newWord.count == wordToGuess.count {
                reset()
                completion?()
            } else if newWord != "" {
                letterPointer += 1
            }
        }
        
        return true
    }
    
    func translateToMorse(_ letter : Character) -> String {
        let letterString = String(letter)
        let morseTranslation = letterDict[letterString] ?? ""
        
        return morseTranslation
    }
    
    
    enum CodeType : String, CaseIterable {
        case dot = "."
        case dash = "-"
        case charSpace = "&"
        case wordSpace = " "
    }
}
