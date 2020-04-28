//
//  Home.swift
//  Attendance
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
    @EnvironmentObject var appState: AppState

    var program: Program
    var programFetchRequest: FetchRequest<Program>
    var fetchedProgram: FetchedResults<Program> { programFetchRequest.wrappedValue }

    var color: UIColor

    init(program: Program) {
        self.program = program
        self.programFetchRequest = FetchRequest(
            entity: Program.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Program.name, ascending: true)],
            predicate: NSPredicate(format: "id == %@", program.id as CVarArg)
        )

        self.color = uiThemeColors[program.color] ?? UIColor.systemBlue
    }

    @State private var showingNewAttendee = false
    @State private var isDirty = false
    @State private var confirmStop = false
    @State private var sortedKey: attendeeSortKey = .lastName

    let gridStyle = StaggeredGridStyle(
        tracks: .min(250),
        axis: .vertical,
        spacing: 16,
        padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
    )

    var body: some View {
        ZStack {
            Grid(self.fetchedProgram.first!.attendeesArray) { attendee in
                AttendeeCard(attendee: attendee, currentEventID: self.appState.currentEvent)
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
            .navigationBarTitle(program.name)
            .navigationBarItems(
                leading: Button("Programs") { self.presentationMode.wrappedValue.dismiss() },
                trailing:
                Button(action: {
                    self.showingNewAttendee = true
                }) {
                    Image(systemName: "plus.circle.fill").resizable().frame(width: 24, height: 24)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0))
                }.sheet(isPresented: $showingNewAttendee, content: {
                    NewAttendee(program: self.program)
                        .environment(\.managedObjectContext, self.managedObjectContext)

                })
            )
            .gridStyle(self.gridStyle)

            EventButton(program: program).environment(\.managedObjectContext, managedObjectContext)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as!
            AppDelegate).persistentContainer.viewContext

        let program = NSEntityDescription.insertNewObject(forEntityName: "Program", into: context) as! Program
        program.name = "Lifeteen"
        program.id = UUID()
        program.color = "blue"

        for _ in 0..<5 {
            let attendee = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
            attendee.firstName = "Evan"
            attendee.lastName = "Hennessy"
            attendee.addToPrograms(program)
            attendee.grade = 10
            attendee.id = UUID()
        }

        return NavigationView {
            Home(program: program)
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
