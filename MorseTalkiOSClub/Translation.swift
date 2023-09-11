//
//  Translation.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 4/4/23.
//
import Foundation

struct Translation: Codable, Identifiable, Hashable {
    static var defaultTranslations: [Translation] = [
        .init(translatedText: "SOS", morseText: "... --- ... ", isPinned: true),
        .init(translatedText: "HI", morseText: ".... .. ", isPinned: true),
    ]
    
    static var mockTranslations: [Translation] = [
        .init(translatedText: "Translation1", morseText: "...", isPinned: false),
        .init(translatedText: "Translation2", morseText: "...", isPinned: true),
        .init(translatedText: "Translation3", morseText: "...", isPinned: false),
        .init(translatedText: "Translation4", morseText: "...", isPinned: true)
    ]
    
    var id = UUID()
    var translatedText: String
    var morseText: String
    var createdAt: Date = Date()
    var isPinned = false
}
