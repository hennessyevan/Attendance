//
//  Timestamp+CoreDataProperties.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/28/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import Foundation
import CoreData


extension Timestamp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timestamp> {
        return NSFetchRequest<Timestamp>(entityName: "Timestamp")
    }

    @NSManaged public var signedInAt: Date
    @NSManaged public var signedOutAt: Date?
    @NSManaged public var id: UUID
    @NSManaged public var event: Event
    @NSManaged public var attendee: Attendee
}
