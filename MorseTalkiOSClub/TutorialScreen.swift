//
//  TutorialView.swift
//  MorseTalkiOSClub
//
//  Created by Tejeshwar Natarajan on 2/23/23.
//

import SwiftUI
import Popovers
import SPConfetti

struct TutorialScreen: View {
    @AppStorage("firstTime") private var isFirstTime = true
    
    @ObservedObject private var handGestureProcessor = HandGestureModel()
    @ObservedObject private var morse = TutorialMorseCode()
    @State private var sheetShowing = false
    @State private var nextView = false
    @State private var showHelpView = false
    @State private var confettiIsPresented = false
        
    @State private var shakeValue: CGFloat = 0.0
    
    var showSkip = true
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 50)
            VStack {
                ZStack(alignment: .top) {
                    CameraFeedView(gestureProcessor: handGestureProcessor) // This is a custom view made to show the camera.
                        .background(.thinMaterial)
                        .cornerRadius(12)
                        .padding()
                        .frame(minHeight: 480)
                    
                    ZStack(alignment: .topTrailing) {
                        InfoPanel
                            .frame(width: 325, height: 125)
                            .background(.thinMaterial)
                            .cornerRadius(12)
                            .padding(.top, 28)
                            .modifier(Shake(animatableData: shakeValue))
//                            .environment(\.colorScheme, .light)
                        
                        OptionsMenu
                            .padding(36)
                            .offset(x: 16)
                    }
                }
            }
        }
        .confetti(isPresented: $confettiIsPresented,
                  animation: .fullWidthToDown,
                  particles: [.arc, .circle, .heart, .polygon, .star, .triangle],
                  duration: 2.5)
        .confettiParticle(\.velocity, 450)
        .navigationTitle("Practice")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Congratulations! What do you want to do next?", isPresented: $sheetShowing, titleVisibility: .visible) {
            Button("Generate New Word") {
                morse.reset()
                handGestureProcessor.morse.removeEverything()
            }
            Button(role: .cancel) {
                nextView.toggle()
            } label: {
                Text("Translate On My Own")
                    .overlay {
                        NavigationLink("Translate On My Own", destination: ContentView(editTranslation: nil))
                            .opacity(0.0)
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if showSkip {
                    Button("Skip") { isFirstTime = false }
                }
            }
        }
        .onAppear {
            if isFirstTime {
                showHelpView = true
            }
            morse.reset()
            handGestureProcessor.morse.removeEverything()
        }
        .onChange(of: handGestureProcessor.morse.morseString) { _ in
            withAnimation {
                if (!morse.checkNewMorse(handGestureProcessor.morse.currString)) {
                    handGestureProcessor.morse.removeLastCurr()
                    shakeValue += 1
                }
            }
        }
        .onChange(of: handGestureProcessor.morse.translatedString) { newValue in
            withAnimation {
                if (!morse.userDidUpdateWord(newValue, completion: {
                    handGestureProcessor.morse.removeEverything()
                    confettiIsPresented = true
                })) {
                    if let _ = newValue[newValue.count - 1] {
                        // let morseOfLastLetter = morse.translateToMorse(lastLetter)
                        //handGestureProcessor.morse.removeMorseSuffix(morse: morseOfLastLetter)
                        handGestureProcessor.morse.removeLastChar()
                    }
                    shakeValue += 1
                }
            }
        }
        .popover(present: $showHelpView, attributes: {
            $0.position = .absolute(originAnchor: .center, popoverAnchor: .center)
        }, view: {
            InfoCard(isShowing: $showHelpView)
                .padding()
                .frame(width: 300, height: 400)
                .background(.thinMaterial)
                .cornerRadius(16.0)
                .shadow(radius: 8.0)
        }) {
            Rectangle()
                .fill(.thinMaterial)
        }
    }
    
    
    // MARK: - Helper Views
    
    var OptionsMenu: some View {
        Menu {
            Button {
                morse.reset()
                handGestureProcessor.morse.removeEverything()
            } label: {
                Label("Generate New Word", systemImage: "arrow.clockwise")
            }
            
            Button {
                showHelpView = true
            } label: {
                Label("Quick Help", systemImage: "questionmark.circle")
            }
        } label: {
            Label("Options", systemImage: "ellipsis.circle.fill")
                .labelStyle(.iconOnly)
        }
        .imageScale(.large)
    }
    
    var InfoPanel: some View {
        VStack(spacing: 12) {
            Text(String(format: "%.2f", handGestureProcessor.timePinchedCount))
            WordView
            MorseView
        }
        
    }
    
    var WordView: some View {
        HStack {
            ForEach(0..<morse.wordToGuess.count, id: \.self) { index in
                if let correctChar = morse.wordToGuess[index] {
                    let myChar: Character? = (index < handGestureProcessor.morse.translatedString.count) ? handGestureProcessor.morse.translatedString[index] : nil
                    if correctChar == myChar {
                        Text(String(correctChar))
                            .foregroundColor(.green)
                            .font(.system(size:40)).fontWeight(.heavy)
                    } else if index == morse.letterPointer {
                        Text(String(correctChar))
                            .font(.system(size:40)).fontWeight(.heavy)
                            .foregroundColor(.orange)
                    } else {
                        Text(String(correctChar))
                            .font(.system(size:40)).fontWeight(.heavy)
                    }
                }
            }
        }
    }
    
    var MorseView: some View {
        HStack {
            ForEach(0..<morse.currentCharMorse.count, id: \.self) { index in
                let morseChar = morse.currentCharMorse[index]
                let myMorse: Character? = (index < handGestureProcessor.morse.currString.count) ? handGestureProcessor.morse.currString[index] : nil
                if morseChar == "-" {
                    dashView(isComplete: myMorse == morseChar, isCurrent: index == handGestureProcessor.morse.currString.count, id: index)
                } else if morseChar == "." {
                    dotView(isComplete: myMorse == morseChar, isCurrent: index == handGestureProcessor.morse.currString.count, id: index)
                }
            }
        }
    }
    
    @ViewBuilder
    private func dashView(isComplete: Bool, isCurrent: Bool, id: Int) -> some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: 50, height: 20)
            .foregroundColor(isComplete ? .green : .primary)
            .opacity(isCurrent || isComplete ? 1 : 0.2)
            .id(id)
            .transition(.scale)
    }
    
    @ViewBuilder
    private func dotView(isComplete: Bool, isCurrent: Bool, id: Int) -> some View {
        Circle()
            .frame(width: 20)
            .foregroundColor(isComplete ? .green : .primary)
            .opacity(isCurrent || isComplete ? 1 : 0.2)
            .id(id)
            .transition(.scale)
    }

}


struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TutorialScreen()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
