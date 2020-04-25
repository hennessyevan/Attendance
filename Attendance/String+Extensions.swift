//
//  String+Extensions.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/20/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

extension String {
    func capitalize() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalize() {
        self = self.capitalize()
    }
}
