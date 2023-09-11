//
//  Flashlight.swift
//  MorseTalkiOSClub
//
//  Created by Sankaet Cheemalamarri on 4/8/23.
//
import SwiftUI
import AVFoundation

class FlashLight {
    private var i = 0
    private var currTranslation: Binding<Translation?>?
    private var morse = "" {
        didSet { i = 0 }
    }
    
    func play(currTranslation: Binding<Translation?>) {
        self.currTranslation = currTranslation
        self.morse = currTranslation.wrappedValue?.morseText ?? ""
        i = 0
        startFlashlight()
    }
    
    private func startFlashlight() {
        if i >= morse.count {
            currTranslation?.wrappedValue = nil
            i = 0
            return
        }
        
        let currCode = morse[i]
        if currCode == "." {
            toggleTorch(on: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.toggleTorch(on: false)
                Thread.sleep(forTimeInterval: 0.5)
                self.i += 1
                self.startFlashlight()
            }
        } else if currCode == "-" {
            toggleTorch(on: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.toggleTorch(on: false)
                Thread.sleep(forTimeInterval: 0.5)
                self.i += 1
                self.startFlashlight()
            }
        } else {
            self.i += 1
            Thread.sleep(forTimeInterval: 1.5)
            self.startFlashlight()
        }
    }
    
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
