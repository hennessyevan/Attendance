//
//  PublishedUserDefault.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/27/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
        } set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
