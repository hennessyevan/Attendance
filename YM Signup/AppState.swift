//
//  AppState.swift
//  YM Signup
//
//  Created by Evan Hennessy on 4/22/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import Foundation

final class AppState: ObservableObject {
    
    private init() { }
    
    static let shared = AppState()
    
    @Published var program: UUID? = nil
    
    var test = "Test"
}
