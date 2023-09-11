//
//  InfoCard.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 4/6/23.
//

import SwiftUI

struct InfoCard: View {
    @Binding var isShowing: Bool
    
    @AppStorage("dash") private var dash = 3.0
    @AppStorage("dot") private var dot = 1.0
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center) {
                Text("Quick Tips")
                    .font(.largeTitle)
                    .bold()
                Divider()
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 50, height: 20)
                        VStack(alignment: .leading) {
                            Text("Dash")
                                .bold()
                            Text(String(format: "Hold your thumb and index finger together for %.1f second(s).", dash))
                                .fontWeight(.light)
                        }
                    }
                    HStack(spacing: 16) {
                        Circle()
                            .frame(width: 50, height: 20)
                        VStack(alignment: .leading) {
                            Text("Dot")
                                .bold()
                            Text(String(format: "Hold your thumb and index finger together for %.1f second(s).", dot))
                                .fontWeight(.light)
                        }
                    }
                    HStack(spacing: 16) {
                        Image(systemName: "character.cursor.ibeam")
                            .foregroundColor(.primary).colorInvert()
                            .imageScale(.large)
                            .frame(width: 50)
                            .padding(.vertical, 12)
                            .background(.primary)
                            .cornerRadius(8.0)
                        VStack(alignment: .leading) {
                            Text("End of letter")
                                .bold()
                            Text("Move your hand away from the camera.")
                                .fontWeight(.light)
                        }
                    }
                }
                .multilineTextAlignment(.leading)
                .padding(8)
            }
            
            Button {
                isShowing = false
            } label: {
                Label("Close", systemImage: "x.circle.fill")
                    .labelStyle(.iconOnly)
            }
            .imageScale(.large)
        }
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard(isShowing: .constant(true))
    }
}
