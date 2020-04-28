//
//  Program+CoreDataProperties.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/25/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import Foundation
import CoreData


extension Program {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Program> {
        return NSFetchRequest<Program>(entityName: "Program")
    }

    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var attendees: NSSet?
    @NSManaged public var events: NSSet?
    
    public var attendeesArray: [Attendee] {
        let set = attendees as? Set<Attendee> ?? []

        // Sort by lastName then grade
        return set.sorted {
            if $0.lastName == $1.lastName {
                return $0.grade < $1.grade
            }
            return $0.lastName < $1.lastName
        }
    }
    
    public var eventsArray: [Event] {
        let set = events as? Set<Event> ?? []

        return set.sorted {
            $0.createdAt < $1.createdAt
        }
    }

}

// MARK: Generated accessors for attendees
extension Program {

    @objc(addAttendeesObject:)
    @NSManaged public func addToAttendees(_ value: Attendee)

    @objc(removeAttendeesObject:)
    @NSManaged public func removeFromAttendees(_ value: Attendee)

    @objc(addAttendees:)
    @NSManaged public func addToAttendees(_ values: NSSet)

    @objc(removeAttendees:)
    @NSManaged public func removeFromAttendees(_ values: NSSet)

}
