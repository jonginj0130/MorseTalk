//
//  WelcomeScreen.swift
//  MorseTalkiOSClub
//
//  Created by Julien Sanchez on 2/17/23.
//

import SwiftUI


struct WelcomeScreen: View {
    
    var body: some View {
            NavigationView {
                ZStack{
                    AnimatedBackground()
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 50)
                    VStack {
                        Spacer()
                        Text("Welcome to")
                            .font(.system(size: 30))
                            .opacity(0.8)
                        Text("MorseTalk!").fontWeight(.heavy)
                            .font(.system(size: 50))
                            .multilineTextAlignment(.center)
                        Spacer()
                        NavigationLink(destination: {
                            TutorialScreen()
                        }, label: {
                            Text("Get Started!").frame(minWidth: 250)
                        })
                        .padding()
                        .buttonStyle(BounceButtonStyle())
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Label("Credits", systemImage: "info.circle.fill")
                                .labelStyle(.iconOnly)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}

struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Color.blue, Color.gray, Color.cyan]
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 6).repeatForever(), value: start)
            .onReceive(timer, perform: { _ in

                self.start = UnitPoint(x: 4, y: 0)
                self.end = UnitPoint(x: 0, y: 2)
                self.start = UnitPoint(x: -4, y: 20)
                self.start = UnitPoint(x: 4, y: 0)
            })
    }
}
public struct BounceButtonStyle: ButtonStyle {
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State var animationTick = true
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.black)
                    .opacity(0.5)
                RoundedRectangle(cornerRadius: 10)
                    .trim(from: animationTick ? 0 : 1, to: 10)
                    .stroke()
                    .foregroundColor(.white)
            }.onReceive(timer) { _ in
                withAnimation(.linear(duration: 1)) {
                    animationTick.toggle()
                }
            }
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
public struct JustBounceButtonStyle: ButtonStyle {
    private let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background{
                Capsule()
                    .foregroundColor(.black)
                    .opacity(0.5)
            }
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

