//
//  SingleProgram.swift
//  Attendance
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

struct SingleProgram: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState

    var program: Program
    var programFetchRequest: FetchRequest<Program>
    var fetchedProgram: FetchedResults<Program> { programFetchRequest.wrappedValue }
    var currentEvent: Event? { fetchedProgram.first!.eventsArray.first(where: { $0.id.uuidString == appState.currentEvent }) }

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

    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 250))
    ]

    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 12, pinnedViews: []) {
                    ForEach(self.fetchedProgram.first!.attendeesArraySorted(by: sortedKey), id: \.self) { attendee in
                        AttendeeCard(attendee: attendee, currentEventID: self.appState.currentEvent)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    }
                }
                .padding(EdgeInsets(top: 32, leading: 16, bottom: 96, trailing: 16))
            }

            EventButton(program: program).environment(\.managedObjectContext, managedObjectContext)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .configureNavigationBar {
            $0.navigationBar.tintColor = .white
            $0.navigationBar.barTintColor = color
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("End \(program.name)") { presentationMode.wrappedValue.dismiss() }.foregroundColor(Color(self.color))
            }
            ToolbarItem(placement: .principal) {
                Text(program.name).font(.title3).bold().foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Member") { showingNewAttendee = true }
            }
        }
        .sheet(isPresented: $showingNewAttendee) {
            NewAttendee(program: program).environment(\.managedObjectContext, managedObjectContext)
        }
        .onAppear {}
    }
}

#if DEBUG
struct SingleProgram_Previews: PreviewProvider {
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
            SingleProgram(program: program)
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
#endif
