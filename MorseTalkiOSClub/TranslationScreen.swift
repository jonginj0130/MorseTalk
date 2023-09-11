//
//  TranslationScreen.swift
//  MorseTalkiOSClub
//
//  Created by Sankaet Cheemalamarri on 4/6/23.
//
import SwiftUI

struct TranslationScreen: View {
    var help : Bool
    @ObservedObject var morse = MorseCode()
    @Binding var time: Double
    var dotTime: Double
    var dashTime: Double
    
    var body: some View {
        let morseString = morse.currString
        let translation = morse.translatedString
        VStack{
            Text(String(format: "%.2f", time))
                .padding(.top, help ?  37.5 : 31)
            HStack(alignment: .center) {
                Spacer()
                Text(translation)
                    .font(.system(size:40)).fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(height: 30).padding(5)
            VStack {
                HStack{
                    ForEach (Array(morseString), id: \.self){ myvalue in
                        if myvalue == "." {
                            Circle()
                                .frame(width: 20, height: 20, alignment: .leading)
                                .foregroundColor(.orange)
                        } else if myvalue == "-" {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 50, height: 20, alignment: .leading)
                                .foregroundColor(.blue)
                        }
                    }
                    if (time != 0) {
                        DotDashAnimation(time: $time, dotTime: dotTime, dashTime: dashTime)
                    }
                }
                .frame(height: 10)
                if (help) {
                    helpScreen()
                        .padding(.bottom, 8)
                }
            }
            .frame(height: help ? 100 : 30).padding(.bottom, help ? 8 : 35)
        }
        .padding(.vertical)
        .background(.thinMaterial)
    }
}

//struct TranslationScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        TranslationScreen(morseString: ".-.-..", time: .constant(1.0), translation: "ABCDE", dotTime: 1.0, dashTime: 3.0)
//    }
//}
