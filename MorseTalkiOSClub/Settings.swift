//
//  Settings.swift
//  MorseTalkiOSClub
//
//  Created by Sankaet Cheemalamarri on 4/6/23.
//

import SwiftUI


struct Settings: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("dash") private var dash = 3.0
    @AppStorage("dot") private var dot = 1.0
    @State private var isEditingDash = false
    @State private var isEditingDot = false
    
    @State private var showTutorial = false

    private let lengthMin = 0.5
    private let stepValue = 0.5
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dash Length"), footer: Text("The duration you must hold your fingers together to register a dash.")) {
                    Stepper(value: $dash, in: (dot + 0.5)...5.0, step: stepValue, label: {
                        HStack {
                            RoundedRectangle(cornerRadius: 8.0)
                                .foregroundColor(.blue)
                                .frame(width: 80, height: 30)
                            Spacer()
                            Text(String(format: "%.1f sec", dash))
                        }
                    })
                    
                }
                
                Section(header: Text("Dot Length"), footer: Text("The duration you must hold your fingers together to register a dot.")) {
                    Stepper(value: $dot, in: lengthMin...(dash-0.5), step: stepValue, label: {
                        HStack {
                            Circle()
                                .foregroundColor(.orange)
                                .frame(height: 30)
                            Spacer()
                            Text(String(format: "%.1f sec", dot))
                        }
                    })
                }
                
                Button("Reset All Settings") {
                    dash = 3.0
                    dot = 1.0
                }
                
                Button("View Tutorial") { showTutorial.toggle() }
                
                Section {
                    NavigationLink("Credits") {
                        CreditScreen()
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }.font(.body.bold())
                }
            }
        }
        .fullScreenCover(isPresented: $showTutorial) {
            NavigationView {
                TutorialScreen(showSkip: false)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") { showTutorial.toggle() }
                        }
                    }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
