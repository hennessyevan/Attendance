//
//  Event+CoreDataProperties.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/25/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Date
    @NSManaged public var name: String?
    @NSManaged public var endedAt: Date
    @NSManaged public var program: Program
    @NSManaged public var attendees: NSSet?

    
    public var attendeesArray: [Attendee] {
        let set = attendees as? Set<Attendee> ?? []

        return set.sorted {
            $0.lastName < $1.lastName
        }
    }
}

// MARK: Generated accessors for attendees
extension Event {

    @objc(addAttendeesObject:)
    @NSManaged public func addToAttendees(_ value: Attendee)

    @objc(removeAttendeesObject:)
    @NSManaged public func removeFromAttendees(_ value: Attendee)

    @objc(addAttendees:)
    @NSManaged public func addToAttendees(_ values: NSSet)

    @objc(removeAttendees:)
    @NSManaged public func removeFromAttendees(_ values: NSSet)

}
