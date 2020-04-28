//
//  AvoidKeyboard.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/27/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import Combine
import SwiftUI

struct AvoidKeyboard<Content>: View where Content: View {
    private let content: Content
    @State private var keyboardHeight: CGFloat = 0

    init(content: Content) {
        self.content = content
    }

    var body: some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension View {
    func avoidKeyboard() -> some View {
        AvoidKeyboard(content: self)
    }
}
