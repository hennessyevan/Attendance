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
