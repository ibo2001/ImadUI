//
//  MeshGradientActivity.swift
//  ImadUI
//
//  Created by Ibrahim Qraiqe on 11/11/2024.
//
import SwiftUI

public struct RainbowOverlay: View {
    @State private var phase: CGFloat = 0
    var radius: CGFloat = 70
    var rainbowWidth: CGFloat = 50
    var blurRadius: CGFloat = 20
    var animationDuration: Double = 5
    
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    
    public init(radius: CGFloat = 70, rainbowWidth: CGFloat = 50, blurRadius: CGFloat = 20, animationDuration: Double = 5) {
        self.radius = radius
        self.rainbowWidth = rainbowWidth
        self.blurRadius = blurRadius
        self.animationDuration = animationDuration
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: radius)
                    .fill(.black.opacity(0.1))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: colors),
                                    center: .center,
                                    angle: .degrees(Double(phase))
                                ),
                                lineWidth: rainbowWidth
                            )
                            .blur(radius: blurRadius)
                            .animation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false),value: phase)
                    )
                    .onAppear {
                        phase = 360
                    }
                    
            }
        }
        .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
    }
}
