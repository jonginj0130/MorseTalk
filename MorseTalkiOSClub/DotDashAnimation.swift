//
//  DotDashAnimation.swift
//  MorseTalkiOSClub
//
//  Created by Sankaet Cheemalamarri on 4/6/23.
//

import SwiftUI

struct DotDashAnimation: View {
    @Namespace var nameSpace
    @Binding var time : Double
    var dotTime : Double
    var dashTime : Double
    var constantCirclePeriod : Bool {
        (time >= dotTime && time <= (dashTime - dotTime)/2)
    }
    var morph : Bool {
        (time > dotTime)
    }
    var body: some View {
        Group {
            if (time <= dotTime) {
                ZStack() {
                    
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 20, alignment: .leading)
                        .overlay(
                            PieShape(progress: Double(time/dotTime))
                                .foregroundColor(.orange)
                                .matchedGeometryEffect(id: "circle", in: nameSpace, anchor: .leading)
                        )
                        //.frame(maxWidth: .infinity)
                        //.animation(Animation.linear, value: time/3.0) // << here !!
                        .aspectRatio(contentMode: .fit)
                    
    //                Circle()
    //                    .frame(width: 45, height: 45, alignment: .leading)
    //                    .foregroundColor(.gray)
    //                    .opacity(0.5)
    //                    .animation(.spring(), value: time)
    //                Circle()
    //                    .trim(from: 0, to: time/3.0)
    //                    .rotationEffect(.init(degrees: -90))
    //                    .frame(width: 45, height: 45, alignment: .leading)
    //                    .foregroundColor(.orange)
    //                    .animation(.spring(), value: time)
                }
            } else if (time > dotTime && time <= dashTime) {
                let numerator = 20 + (20 * (time - dotTime))
                let alternative = numerator / ((dashTime - dotTime) * (2/3))
                let width = constantCirclePeriod ? 20 : (alternative)
                let cornerRad = (10 - (5 * (time - dotTime) / ((dashTime - dotTime))))
                RoundedRectangle(cornerRadius: constantCirclePeriod ? 10 : cornerRad)
                    .frame(width: (width), height: 20, alignment: .leading)
                    .foregroundColor(.orange)
                    .animation(.easeInOut(duration: 0.5), value: time)
                    .matchedGeometryEffect(id: "circle", in: nameSpace, anchor: .leading)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 50, height: 20, alignment: .leading)
                    .foregroundColor(.blue)
                    .opacity(time != 0 ? 0.5 : 1)
                    //.animation(.easeIn, value: time)
                    .matchedGeometryEffect(id: "circle", in: nameSpace, anchor: .leading)
            }
        }
            .animation(.spring(), value: morph)
            .animation(.spring(), value: time)

//
//        Rectangle()
//            .frame(width:morph ? 90 : 45, height: 45, alignment: .leading)
//            .foregroundColor(morph ? .blue: .orange)
//            .cornerRadius(morph ? 4.5 : 90/2)
//            .animation(.spring(), value: morph)
//        Circle()
//            .trim(from: 0, to: 0.5)
//            .foregroundColor(.orange)
    }
}

struct DotDashAnimation_Previews: PreviewProvider {
    static var previews: some View {
        DotDashAnimation(time: .constant(1.0), dotTime: 1.0, dashTime: 3.0)
    }
}
