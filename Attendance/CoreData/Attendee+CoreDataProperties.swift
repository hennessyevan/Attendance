//
//  Attendee+CoreDataProperties.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/25/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import CoreData
import Foundation

extension Attendee {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attendee> {
        return NSFetchRequest<Attendee>(entityName: "Attendee")
    }

    @NSManaged public var firstName: String
    @NSManaged public var grade: Int32
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?
    @NSManaged public var lastName: String
    @NSManaged public var sex: Int16
    @NSManaged public var programs: NSSet?
    @NSManaged public var events: NSSet?

    public var wrappedImage: Data {
        image ?? Data()
    }

    public var programsArray: [Program] {
        let set = programs as? Set<Program> ?? []

        return set.sorted {
            $0.name < $1.name
        }
    }
}

// MARK: Generated accessors for programs

extension Attendee {
    @objc(addProgramsObject:)
    @NSManaged public func addToPrograms(_ value: Program)

    @objc(removeProgramsObject:)
    @NSManaged public func removeFromPrograms(_ value: Program)

    @objc(addPrograms:)
    @NSManaged public func addToPrograms(_ values: NSSet)

    @objc(removePrograms:)
    @NSManaged public func removeFromPrograms(_ values: NSSet)
}

// MARK: Generated accessors for events

extension Attendee {
    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)
}
