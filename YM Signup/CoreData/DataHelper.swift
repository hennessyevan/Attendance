//
//  DataHelper.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
import CoreData

public class DataHelper {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func seedAttendees() {
        let attendees = [
            (firstName: "Brigid", lastName: "Alfonso"),
            (firstName: "Hue", lastName: "Frieda"),
            (firstName: "Jolyn", lastName: "Sherrill"),
            (firstName: "Florinda", lastName: "Josephine"),
            (firstName: "Rudolf", lastName: "Russell"),
            (firstName: "Kip", lastName: "Tricia"),
            (firstName: "Ricki", lastName: "Rodrick"),
            (firstName: "Chong", lastName: "Lorena"),
            (firstName: "Odessa", lastName: "Jonnie"),
            (firstName: "Sanjuana", lastName: "Denise")
        ]
        
        for attendee in attendees {
            let newAttendee = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
            newAttendee.id = UUID()
            newAttendee.firstName = attendee.firstName
            newAttendee.lastName = attendee.lastName
            newAttendee.grade = Int32.random(in: 6...12)
        }
        
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
                print("Name: \(attendee.firstName!) \(attendee.lastName!)")
            }
        } catch {}
    }
}
