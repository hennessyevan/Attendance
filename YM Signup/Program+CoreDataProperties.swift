//
//  Program+CoreDataProperties.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/25/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import Foundation
import CoreData


extension Program {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Program> {
        return NSFetchRequest<Program>(entityName: "Program")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var id: UUID?
    @NSManaged public var attendees: NSSet?
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var wrappedColor: String {
        color ?? "blue"
    }
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var attendeesArray: [Attendee] {
        let set = attendees as? Set<Attendee> ?? []
        
        return set.sorted {
            $0.wrappedLastName < $1.wrappedLastName
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
