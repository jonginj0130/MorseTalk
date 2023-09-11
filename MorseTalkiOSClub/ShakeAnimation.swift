//
//  ShakeAnimation.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 4/6/23.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 15
    var shakesPerUnit = 4
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
