//
//  Home.swift
//  YM Signup
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import Grid
import SwiftUI

struct Home: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    var program: Program
    var fetchRequest: FetchRequest<Program>
    var fetchedResults: FetchedResults<Program> { fetchRequest.wrappedValue }

    init(program: Program) {
        self.program = program
        self.fetchRequest = FetchRequest(
            entity: Program.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", program.wrappedId as CVarArg)
        )
    }

    @State private var showingNewAttendee = false

    let gridStyle = StaggeredGridStyle(
        tracks: .min(250),
        axis: .vertical,
        spacing: 16,
        padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
    )

    var body: some View {
        Grid(self.fetchedResults.first!.attendeesArray) { attendee in
                AttendeeCard(person: attendee)
            }
            .navigationBarTitle(program.wrappedName)
            .navigationBarItems(
                leading: Button("Programs") { self.presentationMode.wrappedValue.dismiss() },
                trailing:
                Button(action: {
                    self.showingNewAttendee = true
                }) {
                    Image(systemName: "plus.circle.fill").resizable().frame(width: 24, height: 24)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0))
                }.sheet(isPresented: $showingNewAttendee, content: {
                    NewAttendee(program: self.program).environment(\.managedObjectContext, self.managedObjectContext)
                })
            )
            .gridStyle(self.gridStyle)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let attendee = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
            attendee.firstName = "Evan"
            attendee.lastName = "Hennessy"
            attendee.grade = 10
            attendee.id = UUID()
        
        return Home(program: Program()).environment(\.managedObjectContext, context)
    }
}
