//
//  Event+CoreDataProperties.swift
//  Attendance
//
//  Created by Evan Hennessy on 5/1/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import Foundation
import CoreData

extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var endedAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var state: Bool
    @NSManaged public var name: String?
    @NSManaged public var attendees: NSSet?
    @NSManaged public var program: Program
    @NSManaged public var timestamps: NSSet?
    
    public var attendeesArray: [Attendee] {
        let set = attendees as? Set<Attendee> ?? []

        return set.sorted {
            $0.lastName < $1.lastName
        }
    }
    
    public var timestampsArray: [Timestamp] {
        let set = timestamps as? Set<Timestamp> ?? []

        return set.sorted {
            $0.signedInAt < $1.signedInAt
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

// MARK: Generated accessors for timestamps
extension Event {

    @objc(addTimestampsObject:)
    @NSManaged public func addToTimestamps(_ value: Timestamp)

    @objc(removeTimestampsObject:)
    @NSManaged public func removeFromTimestamps(_ value: Timestamp)

    @objc(addTimestamps:)
    @NSManaged public func addToTimestamps(_ values: NSSet)

    @objc(removeTimestamps:)
    @NSManaged public func removeFromTimestamps(_ values: NSSet)

}
