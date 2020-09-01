//
//  Program+CoreDataProperties.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/25/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import CoreData
import Foundation

enum attendeeSortKey {
    case lastName, firstName, grade
}

extension Program {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Program> {
        return NSFetchRequest<Program>(entityName: "Program")
    }

    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var state: Int32
    @NSManaged public var name: String
    @NSManaged public var attendees: NSSet?
    @NSManaged public var events: NSSet?

    /**
     Sorted by lastName then grade
     */
    public var attendeesArray: [Attendee] {
        let set = attendees as? Set<Attendee> ?? []

        return set.sorted {
            if $0.lastName == $1.lastName {
                return $0.grade < $1.grade
            }
            return $0.lastName < $1.lastName
        }
    }

    /**
     ## Default
     Sorted by lastName then grade

     - Parameter by: The attendee paramater to sort by
     */
    func attendeesArraySorted(by: attendeeSortKey) -> [Attendee] {
        let set = attendees as? Set<Attendee> ?? []

        switch by {
        case .firstName:
            return set.sorted {
                if $0.firstName == $1.firstName {
                    if $0.lastName == $0.lastName {
                        return $0.grade < $1.grade
                    }
                    return $0.lastName < $1.lastName
                }
                return $0.firstName < $1.firstName
            }
        case .lastName:
            return set.sorted {
                if $0.lastName == $1.lastName {
                    if $0.firstName == $0.firstName {
                        return $0.grade < $1.grade
                    }
                    return $0.firstName < $1.firstName
                }
                return $0.lastName < $1.lastName
            }
        case .grade:
            return set.sorted {
                if $0.grade == $1.grade {
                    if $0.firstName == $0.firstName {
                        return $0.grade < $1.grade
                    }
                    return $0.firstName < $1.firstName
                }
                return $0.grade < $1.grade
            }
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
