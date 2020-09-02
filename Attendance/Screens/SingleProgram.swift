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

    var hasMembers: Bool { program.attendeesArray.count > 0 }

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
    @State private var showProgramBar = false
    @State private var sortedKey: attendeeSortKey = .lastName

    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 250))
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ProgramBar(program: program, color: color, showProgramBar: showProgramBar)

            if hasMembers {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 12, pinnedViews: []) {
                        ForEach(fetchedProgram.first!.attendeesArraySorted(by: sortedKey), id: \.self) { attendee in
                            AttendeeCard(attendee: attendee, currentEventID: appState.currentEvent)
                                .environment(\.managedObjectContext, managedObjectContext)
                        }
                    }
                    .padding(EdgeInsets(top: 32, leading: 16, bottom: 96, trailing: 16))
                }
            } else {
                ZStack {
                    Color.clear
                    NewMemberButton(showingNewAttendee: $showingNewAttendee)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .configureNavigationBar {
            $0.navigationBar.tintColor = .white
            $0.navigationBar.barTintColor = color
            $0.navigationBar.shadowImage = UIImage()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("End \(program.name)") { presentationMode.wrappedValue.dismiss() }.foregroundColor(Color(color))
            }
            ToolbarItem(placement: .principal) {
                Text(program.name).font(.title3).bold().foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(showProgramBar ? "Hide Toolbar" : "Show Toolbar") {
                    withAnimation {
                        showProgramBar.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewAttendee) {
            NewAttendee(program: program).environment(\.managedObjectContext, managedObjectContext)
        }
    }
}

struct NewMemberButton: View {
    @Binding var showingNewAttendee: Bool

    var body: some View {
        Button(action: { showingNewAttendee = true }) {
            Text("Add Member").bold()
        }
        .padding(.horizontal, 32)
        .padding()
        .background(Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(8)
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
            attendee.image = UIImage(named: String(Int.random(in: 0...2)))!.jpegData(compressionQuality: 1.0)
        }

        return NavigationView {
            SingleProgram(program: program)
                .environment(\.managedObjectContext, context)
                .environmentObject(AppState())
        }.previewDevice("iPad Pro (11-inch) (2nd generation)").navigationViewStyle(StackNavigationViewStyle())
    }
}
#endif
