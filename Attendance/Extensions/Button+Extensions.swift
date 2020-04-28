//
//  Button+Extensions.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    var scaleAmount: CGFloat?
    
    func makeBody(configuration: Configuration) -> some View {
        ScaleButton(configuration: configuration, scaleAmount: scaleAmount)
    }
}

private extension ScaleButtonStyle {
    struct ScaleButton: View {
        
        @Environment(\.isEnabled) var isEnabled
        
        let configuration: ScaleButtonStyle.Configuration
        let scaleAmount: CGFloat
        
        init(configuration: ScaleButtonStyle.Configuration, scaleAmount: CGFloat?) {
            self.configuration = configuration
            self.scaleAmount = scaleAmount ?? 0.9
        }
        
        var body: some View {
            return configuration.label
                .foregroundColor(isEnabled ? .blue : .gray)
                .opacity(configuration.isPressed ? 0.75 : 1.0)
                .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
        }
        
    }
}

struct TouchGestureViewModifier: ViewModifier {
    let touchBegan: () -> Void
    let touchEnd: (Bool) -> Void

    @State private var hasBegun = false
    @State private var hasEnded = false

    private func isTooFar(_ translation: CGSize) -> Bool {
        let distance = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
        return distance >= 20.0
    }

    func body(content: Content) -> some View {
        content.gesture(DragGesture(minimumDistance: 0)
                .onChanged { event in
                    guard !self.hasEnded else { return }

                    if self.hasBegun == false {
                        self.hasBegun = true
                        self.touchBegan()
                    } else if self.isTooFar(event.translation) {
                        self.hasEnded = true
                        self.touchEnd(false)
                    }
                }
                .onEnded { event in
                    if !self.hasEnded {
                        let success = !self.isTooFar(event.translation)
                        self.touchEnd(success)
                    }
                    self.hasBegun = false
                    self.hasEnded = false
                })
    }
}

extension View {
    func onTouchGesture(touchBegan: @escaping () -> Void = {},
                        touchEnd: @escaping (Bool) -> Void = { _ in }) -> some View {
        modifier(TouchGestureViewModifier(touchBegan: touchBegan, touchEnd: touchEnd))
    }
}
