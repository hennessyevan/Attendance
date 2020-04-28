//
//  Toast.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/27/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct Toast<Presenting>: View where Presenting: View {
    @Binding var isPresenting: Bool

    let presenting: () -> Presenting

    var title: String
    var icon: Image? = Image(systemName: "checkmark")
    var subtitle: String?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting()

                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        self.icon
                            .font(.system(size: 75, weight: .semibold, design: .rounded))
                            .padding(.vertical, 24)

                        Text(self.title)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))

                        if self.subtitle != nil {
                            Text(self.subtitle!)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                    }
                }
                .frame(width: min(geometry.size.width / 2, 200), height: min(geometry.size.width / 2, 200), alignment: .center)
                .background(BlurView(style: .systemMaterial))
                .foregroundColor(Color.primary)
                .cornerRadius(14)
                .animation(.interpolatingSpring(stiffness: 100.0, damping: 10))
                .scaleEffect(self.isPresenting ? 1 : 0.9)
                .opacity(self.isPresenting ? 1 : 0)
            }
        }
    }
}

extension View {
    func toast(isPresenting: Binding<Bool>, title: String) -> some View {
        Toast(isPresenting: isPresenting, presenting: { self }, title: title)
    }
    
    func toast(isPresenting: Binding<Bool>, title: String, icon: Image) -> some View {
        Toast(isPresenting: isPresenting, presenting: { self }, title: title, icon: icon)
    }
    
    func toast(isPresenting: Binding<Bool>, title: String, subtitle: String) -> some View {
        Toast(isPresenting: isPresenting, presenting: { self }, title: title, subtitle: subtitle)
    }
    
    func toast(isPresenting: Binding<Bool>, title: String, icon: Image, subtitle: String) -> some View {
        Toast(isPresenting: isPresenting, presenting: { self }, title: title, icon: icon, subtitle: subtitle)
    }
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Text("Hello")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .edgesIgnoringSafeArea(.all)
        .toast(isPresenting: .constant(true), title: "Added", icon: Image(systemName: "text.badge.plus"))
    }
}
