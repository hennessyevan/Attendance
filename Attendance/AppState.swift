//
//  AppState.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/22/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import Combine
import Foundation

final class AppState: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()

    @UserDefault(key: "currentEvent", defaultValue: "") var currentEvent: String

    private var notificationSubscription: AnyCancellable?

    init() {
        notificationSubscription = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).sink { _ in
            self.objectWillChange.send()
        }
    }
}
