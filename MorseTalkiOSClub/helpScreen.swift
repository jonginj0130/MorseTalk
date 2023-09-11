//
//  helpScreen.swift
//  MorseTalkiOSClub
//
//  Created by Sankaet Cheemalamarri on 4/6/23.
//


import SwiftUI

struct helpScreen: View {
    let keys : [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"]
    let values: [String] = [".-", "-...","-.-.","-..",".","..-.","--.","....","..",".---","-.-",".-..","--","-.","---",".--.","--.-",".-.","...","-","..-","...-",".--","-..-","-.--","--..",".----","..---","...--","....-",".....","-....","--...","---..","----.","-----"]
    @State private var isExpanded : [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView (.horizontal) {
                HStack(){
                    ForEach(0..<values.count, id: \.self) {i in
                        VStack(alignment: .leading) {
                            let morsevalues = values[i]
                            HStack(spacing: 8) {
                                Text("\(keys[i])")
                                    .font(.system(size:20)).fontWeight(.bold)
                                if isExpanded[i] {
                                    ForEach(Array(morsevalues).indices, id: \.self){ myvalue in
                                        morseView(morse: morsevalues[myvalue])
                                            .transition(.asymmetric(insertion: insertionTransition(myvalue), removal: removalTransition(myvalue, totalCount: morsevalues.count)))
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                            .frame(minWidth: 30, minHeight: 30)
                            .background {
                                RoundedRectangle(cornerRadius: !isExpanded[i] ? 15 : 8.0)
                                    .fill(.secondary)
                            }
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    isExpanded[i].toggle()
                                }
                            }
                        }
                    }
                }
                .padding([.top, .bottom, .horizontal], 10)
            }
        }
    }
    
    @ViewBuilder
    func morseView(morse: Character?) -> some View {
        if morse == "." {
            Circle()
                .fill(Color.orange)
                .frame(width: 10, height: 10)
        } else if morse == "-" {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.blue)
                .frame(width: 25, height: 10)
        }
    }
    
    func rectangleWidth(morseText: String) -> CGFloat {
        var retVal: CGFloat = 0.0
        for morse in morseText {
            retVal += (morse == ".") ? 10 : 25
        }
        
        retVal += CGFloat(morseText.count * 12)
        
        return retVal
    }
    
    func insertionTransition(_ index: Int) -> AnyTransition {
        AnyTransition
        .move(edge: .leading)
        .combined(with: .scale(scale: 0.4))
        .combined(with: .opacity)
        .animation(.spring().delay(Double(index) / 15))
    }
                   
    func removalTransition(_ index: Int, totalCount: Int) -> AnyTransition {
        .move(edge: .leading)
        .combined(with: .scale(scale: 0.2))
        .combined(with: .opacity)
        .animation(.spring(response: Double(totalCount - 1 - index) / 5))
    }
                   
}

struct helpScreen_Previews: PreviewProvider {
    static var previews: some View {
        helpScreen()
    }
}
