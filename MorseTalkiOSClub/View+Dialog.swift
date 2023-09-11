////
////  View+Dialog.swift
////  MorseTalkiOSClub
////
////  Created by Tejeshwar Natarajan on 3/30/23.
////
//
//import SwiftUI
//
//extension View {
//    func showDialog(sheetShowing: Binding<Bool>, tutorialWord: (String, String), morse: TutorialMorseCode, handGestureProcessor: HandGestureModel, nextView: Binding<Bool>) {
//        self
//            .confirmationDialog("Congratulations! What do you want to do next?", isPresented: sheetShowing) {
//                Button("Generate New Word") {
//                    tutorialWord = morse.displayGuide()
//                    handGestureProcessor.morse.removeEverything()
//                }
//
//                Button("Translate On My Own") {
//                    nextView.wrappedValue.toggle()
//                }
//                .background (
//                    NavigationL
//                    NavigationLink(destination: ContentView(), isActive: nextView)
//                )
//            }
//    }
//}
