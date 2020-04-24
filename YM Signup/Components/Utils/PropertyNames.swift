//
//  PropertyNames.swift
//  YM Signup
//
//  Created by Evan Hennessy on 4/23/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames {
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.compactMap{ $0.label }
    }
}
