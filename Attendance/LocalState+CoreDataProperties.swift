//
//  LocalState+CoreDataProperties.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/25/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import Foundation
import CoreData


extension LocalState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalState> {
        return NSFetchRequest<LocalState>(entityName: "LocalState")
    }

    @NSManaged public var currentEvent: UUID

}
