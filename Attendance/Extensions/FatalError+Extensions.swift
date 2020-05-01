//
//  FatalError+Extensions.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/30/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

func fatalError<T>(
    _ message: String,
    line: UInt = #line,
    file: StaticString = #file) -> T
{
    Swift.fatalError(message)
}
