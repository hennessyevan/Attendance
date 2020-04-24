//
//  Attendee+CoreDataProperties.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/25/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
//

import CoreData
import Foundation

let Sex = [
    0: "male",
    1: "female"
]

extension Attendee {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attendee> {
        return NSFetchRequest<Attendee>(entityName: "Attendee")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var image: Data?
    @NSManaged public var grade: Int32
    @NSManaged public var sex: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var programs: NSSet?
    
    public var wrappedImage: Data {
        image ?? Data()
    }

    public var wrappedFirstName: String {
        firstName ?? "Unknown"
    }

    public var wrappedLastName: String {
        lastName ?? "Unknown"
    }

    public var wrappedId: UUID {
        id ?? UUID()
    }

    public var wrappedGrade: Int32 {
        grade
    }

    public var programsArray: [Program] {
        let set = programs as? Set<Program> ?? []

        return set.sorted {
            $0.wrappedName < $1.wrappedName
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
