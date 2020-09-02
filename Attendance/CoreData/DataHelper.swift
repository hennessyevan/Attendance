//
//  DataHelper.swift
//  Attendance
//
//  Created by Evan Hennessy on 3/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
import CoreData
import SwiftUI

public class DataHelper {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func seedAttendees() {
        let lifeteen = NSEntityDescription.insertNewObject(forEntityName: "Program", into: context) as! Program
        lifeteen.id = UUID()
        lifeteen.name = "Lifeteen"
        lifeteen.color = "blue"
        
        let edge = NSEntityDescription.insertNewObject(forEntityName: "Program", into: context) as! Program
        edge.id = UUID()
        edge.name = "Edge"
        edge.color = "green"
        
        let lifeteenAttendees = [
            (firstName: "Brigid", lastName: "Alfonso"),
            (firstName: "Hue", lastName: "Frieda"),
            (firstName: "Jolyn", lastName: "Sherrill"),
            (firstName: "Florinda", lastName: "Josephine"),
            (firstName: "Rudolf", lastName: "Russell"),
            (firstName: "Kip", lastName: "Tricia"),
            (firstName: "Brigid", lastName: "Alfonso"),
            (firstName: "Hue", lastName: "Frieda"),
            (firstName: "Jolyn", lastName: "Sherrill"),
            (firstName: "Florinda", lastName: "Josephine"),
        ]
        
        let edgeAttendees:[(firstName: String, lastName: String)] = [
//            (firstName: "Ricki", lastName: "Rodrick"),
//            (firstName: "Chong", lastName: "Lorena"),
//            (firstName: "Odessa", lastName: "Jonnie"),
//            (firstName: "Sanjuana", lastName: "Denise"),
        ]
        
        func addAttendees(attendees: [(firstName: String, lastName: String)], program: Program) {
            for attendee in attendees {
                let newAttendee = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
                newAttendee.id = UUID()
                newAttendee.firstName = attendee.firstName
                newAttendee.lastName = attendee.lastName
                newAttendee.addToPrograms(program)
                newAttendee.grade = Int32.random(in: 6...12)
                newAttendee.image = UIImage(named: String(Int.random(in: 0...2)))!.jpegData(compressionQuality: 1.0)
            }
        }
        
        addAttendees(attendees: lifeteenAttendees, program: lifeteen)
        addAttendees(attendees: edgeAttendees, program: edge)
        
        do {
            try context.save()
        } catch {}
    }
    
    public func printAllAttendees() {
        let attendeeFetchRequest: NSFetchRequest<Attendee> = Attendee.fetchRequest()
        let allAttendees: [Attendee]
        
        do {
            allAttendees = try context.fetch(attendeeFetchRequest)
            
            for attendee in allAttendees {
                print("Name: \(attendee.firstName) \(attendee.lastName)")
            }
        } catch {}
    }
}
