//
//  HandGestureProcessor.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 10/11/22.
//
import Foundation
import CoreGraphics
import SwiftUI

class HandGestureModel: ObservableObject {
    // Distance
    // The current state of the hand
    // The time of contact
    typealias PointsPair = (thumbTip: CGPoint, indexTip: CGPoint)
    let pinchThreshold: CGFloat
    //var countThreshold = 3.0
    @Published var morse : MorseCode = MorseCode();
    
    enum HandState {
        case pinched, apart, inProgress, unknown
    }
    
    @Published var timePinchedCount = 0.0
    var timePinchedTimer: Timer?
    var isPinchedCount = 0
    var isApartCount = 0
    var dashThreshold : Double {
        var currentThresh = UserDefaults.standard.double(forKey: "dash")
        if currentThresh == 0 {
            currentThresh = 3.0
        }
        return currentThresh
    }
    
    var dotThreshold : Double {
        var currentThresh = UserDefaults.standard.double(forKey: "dot")
        if currentThresh == 0 {
            currentThresh = 1.0
        }
        return currentThresh
    }
    
    var currentState: HandState = .unknown {
        willSet {
            if (currentState != .pinched && currentState != .unknown && newValue == .pinched) {
                timePinchedTimer = .scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                    self.timePinchedCount += 0.2
                }
            }
        }
    }
    
    init(pinchThreshold: CGFloat = 40) {
        self.pinchThreshold = pinchThreshold
        //self.countThreshold = UserDefaults.standard.double(forKey: "duration")
    }
    
    func reset() {
        currentState = .unknown
        timePinchedTimer?.invalidate()
        timePinchedCount = 0
        isApartCount = 0
        isPinchedCount = 0
    }
    
    func updatePoints(pointsPair: PointsPair) {
        withAnimation {
            let distance = pointsPair.indexTip.distance(from: pointsPair.thumbTip)
            if distance <= pinchThreshold {
                isPinchedCount += 1
                isApartCount = 0
    //            if (currentState != .pinched) {
    //                currentState = .pinched
    //            }
                if (isPinchedCount < Int(dashThreshold)) {
                    currentState = .inProgress
                } else {
                    currentState = .pinched
                }
    //            currentState = (isPinchedCount > countThreshold && currentState != .pinched) ? .pinched : .inProgress
            } else if (distance > pinchThreshold) {
                isApartCount += 1
                if (timePinchedCount >= dashThreshold) {
                    morse.addChar("-")
                } else if timePinchedCount >= dotThreshold {
                    morse.addChar(".")
                }
                //            } else if ("charspace") {
                //                morse.addChar("&")
                //            } else if ("wordspace") {
                //                morse.addChar(" ")
                //            }
                isPinchedCount = 0
                // timePinchedTimer = 0
                timePinchedTimer?.invalidate()
                currentState = (isApartCount > Int(dashThreshold)) ? .apart : .inProgress
                timePinchedCount = 0
            }
            
            
            if (currentState == .unknown) {
                timePinchedCount = 0
                timePinchedTimer?.invalidate()
            }
    //        } else {
    //            currentState = .unknown
    //            timePinchedCount = 0
    //            timePinchedTimer?.invalidate()
    //        }
        }
    }
}

extension CGPoint {
    
    func distance(from otherPoint: CGPoint) -> CGFloat {
        return hypot(self.x - otherPoint.x, self.y - otherPoint.y)
    }
    
}
