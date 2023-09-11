//
//  HomeView.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 4/4/23.
//
import SwiftUI

struct HomeView: View {
    @AppStorage("firstTime") private var isFirstTime = true
    @AppStorage("translations") var translations: [Translation] = Translation.defaultTranslations
    @State private var showMainView = false
    @State private var showSettingsView = false
    @State private var flashlight = FlashLight()
    @State private var currFlashlightTranslation: Translation?
    
    var pinnedTranslations: [Translation] {
        translations.filter({ $0.isPinned })
    }
    
    var unpinnedTranslations: [Translation] {
        translations.filter({ !$0.isPinned })
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                List {
                    if !pinnedTranslations.isEmpty {
                        Section(header: Label("Pinned", systemImage: "pin")) {
                            ForEach(pinnedTranslations) { translation in
                                NavigationLink {
                                    ContentView(editTranslation : translation)
                                } label: {
                                    translationRow(translation: translation)
                                }
                                
                            }
                            .onDelete { indexSet in
                                indexSet.forEach({ i in
                                    let originalIndex = translations.firstIndex(of: pinnedTranslations[i])
                                    translations.remove(at: originalIndex!)
                                })
                            }
                        }
                    }
                    
                    Section {
                        ForEach(unpinnedTranslations) { translation in
                            NavigationLink {
                                ContentView(editTranslation : translation)
                            } label: {
                                translationRow(translation: translation)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach({ i in
                                let originalIndex = translations.firstIndex(of: unpinnedTranslations[i])
                                translations.remove(at: originalIndex!)
                            })
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Recent Translations")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showSettingsView.toggle()
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            ContentView()
                        } label: {
                            Label("New Translation", systemImage: "plus.circle.fill")
                        }
                        
                    }
                }
                .onDisappear {
                    currFlashlightTranslation = nil
                    flashlight.play(currTranslation: .constant(nil))
                }
            }
            .sheet(isPresented: $showSettingsView, content: {
                Settings()
            })
            .fullScreenCover(isPresented: $isFirstTime) {
                WelcomeScreen()
            }
            
        }
    }
    @ViewBuilder
    func pinTranslationButton(translation: Translation) -> some View {
        Button {
            withAnimation(.easeInOut) {
                let index = translations.firstIndex(of: translation)
                translations[index!].isPinned.toggle()
            }
        } label: {
            Label("Pin", systemImage: "pin")
        }
        .tint(.orange)
    }
    
    @ViewBuilder
    func flashlightButton(translation: Translation) -> some View {
        Button {
            withAnimation {
                if currFlashlightTranslation != translation {
                    currFlashlightTranslation = translation
                    flashlight.play(currTranslation: $currFlashlightTranslation)
                } else {
                    currFlashlightTranslation = nil
                    flashlight.play(currTranslation: .constant(nil))
                }
            }
        } label: {
            Label("Flashlight", systemImage: currFlashlightTranslation != translation ? "flashlight.on.fill" : "flashlight.off.fill")
        }
        .tint(currFlashlightTranslation != nil && currFlashlightTranslation != translation ? .gray : .blue)
        .disabled(currFlashlightTranslation != nil && currFlashlightTranslation != translation)
    }
    
    
    
    @ViewBuilder
    func translationRow(translation: Translation) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(translation.translatedText)
                    .font(.system(size:20)).fontWeight(.bold)
                HStack {
                    ForEach((0..<translation.morseText.count), id: \.self) {i in
                        if(translation.morseText[i] == "-") {
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(Color.blue)
                                .frame(width: 25, height: 10)
                        } else if (translation.morseText[i] == ".") {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 10, height: 10)
                        } else {
                            Text("  ")
                        }
                    }
                    //Text(translation.morseText)
                }
            }
            
            Spacer()
            
            if translation == currFlashlightTranslation {
                Image(systemName: "flashlight.on.fill")
                    .foregroundColor(.blue)
                    .imageScale(.large)
                    .transition(.scale)
            }
        }
        .swipeActions(edge: .leading, content: {
            pinTranslationButton(translation: translation)
            flashlightButton(translation: translation)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
    
}
