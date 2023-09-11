//
//  ContentView.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 10/10/22.

import SwiftUI
import DYPopoverView
import Popovers

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("translations") var translations: [Translation] = Translation.defaultTranslations
    @ObservedObject var handGestureProcessor = HandGestureModel()
    var editTranslation : Translation?
    
    init(editTranslation: Translation? = nil) {
        self.editTranslation = editTranslation
        self.handGestureProcessor.morse.morseString = editTranslation?.morseText ?? ""
        self.handGestureProcessor.morse.translatedString = editTranslation?.translatedText ?? ""
    }
    
    @State private var help = false
    @State private var showInfoCard = false
    
    var body: some View {
        VStack {
//            Text("\(handGestureProcessor.timePinchedCount)")
//            Text(handGestureProcessor.morse.currString)
//            Text(handGestureProcessor.morse.translatedString)
            ZStack{
                AnimatedBackground()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 50)
                VStack {
                    GeometryReader { geo in
                        CameraFeedView(gestureProcessor: handGestureProcessor) // This is a custom view made to show the camera.
                            .background(.thinMaterial)
                            .cornerRadius(10.0)
                            .padding(.horizontal)
                            .overlay(alignment: .topTrailing) {
                                TranslationScreen(help: help, morse: handGestureProcessor.morse, time: $handGestureProcessor.timePinchedCount, dotTime: handGestureProcessor.dotThreshold, dashTime:handGestureProcessor.dashThreshold)
                                //.frame(width: geo.size.width - 16, height: geo.size.height / 3)
                                    .frame(height: help ? 175 : 140)
                                    //.animation(.easeInOut)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 16)
                                    .padding()
                                
                            }
                            .overlay(alignment: .topLeading) {
                                Button {
                                    withAnimation {
                                        help.toggle()
                                    }
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .imageScale(.large)
                                }
//                                .popoverView(content: {
//                                    helpScreen()
//                                        .onTapGesture {
//                                            self.help = false
//                                        }
//                                }, background: {
//                                    Color(.secondarySystemBackground)
//                                }, isPresented: self.$help, frame: .constant(CGRect(x:0, y:0, width: 200, height: 400)), anchorFrame: nil, popoverType: .popout, position: .bottomRight, viewId: "helpScreen")
                                .padding(.leading, 32)
                                .padding(.top, 16)
                                .padding()
                            }
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    showInfoCard.toggle()
                                } label: {
                                    Image(systemName: "questionmark.circle.fill")
                                        .imageScale(.large)
                                }
                                .padding(.trailing, 32)
                                .padding(.top, 16)
                                .padding()
                            }
                        //                        .overlay(alignment: .bottom) {
                        //                            VStack {
                        //                                Text("morseString (for debugging):")
                        //                                Text(handGestureProcessor.morse.morseString)
                        //                                    .font(.system(size:20))
                        //                            }
                        //                        }
                    }
//                    .frame(height: help ? screenSize().height * (1/2) : screenSize().height - (screenSize().height * 0.25), alignment: .top)
//                    .animation(.easeInOut)
                }
            }
            HStack{
                Button {
                    handGestureProcessor.morse.removeLastChar()
                    handGestureProcessor.objectWillChange.send()
                } label: {
                    Text("Backspace")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
                .padding(.leading, 15)
                .disabled(handGestureProcessor.morse.currString.count != 0)
                .frame(alignment: .top)
                Button {
                    handGestureProcessor.morse.addChar(" ")
                } label: {
                    Text("Add Space")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.trailing, 15)
                .disabled(handGestureProcessor.morse.currString.count != 0)
                .frame(alignment: .top)
            }
            .padding(.bottom, 20)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if editTranslation == nil {
                        translations.append(Translation(translatedText: handGestureProcessor.morse.translatedString, morseText: handGestureProcessor.morse.morseString))
                    } else {
                        let index = translations.firstIndex(of: editTranslation!)
                        translations[index!].morseText = handGestureProcessor.morse.morseString
                        translations[index!].translatedText = handGestureProcessor.morse.translatedString
                    }

                    
                    handGestureProcessor.morse.removeEverything()
                    
                    dismiss()
                }
                .disabled(handGestureProcessor.morse.translatedString.isEmpty || !handGestureProcessor.morse.currString.isEmpty)
            }
        }
        .popover(present: $showInfoCard, attributes: {
            $0.position = .absolute(originAnchor: .center, popoverAnchor: .center)
        }, view: {
            InfoCard(isShowing: $showInfoCard)
                .padding()
                .frame(width: 300, height: 400)
                .background(.thinMaterial)
                .cornerRadius(16.0)
                .shadow(radius: 8.0)
        }) {
            Rectangle()
                .fill(.thinMaterial)
        }
        .onAppear {
            self.handGestureProcessor.morse.morseString = editTranslation?.morseText ?? ""
            self.handGestureProcessor.morse.translatedString = editTranslation?.translatedText ?? ""
        }
        .onDisappear {
            handGestureProcessor.morse.removeEverything()
        }
    }
}

func screenSize() -> CGSize {
    return UIScreen.main.bounds.size
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(editTranslation: nil)
    }
}

