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

    var program: Program
    var fetchRequest: FetchRequest<Program>
    var fetchedResults: FetchedResults<Program> { fetchRequest.wrappedValue }
    var color: UIColor

    init(program: Program) {
        self.program = program
        self.fetchRequest = FetchRequest(
            entity: Program.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Program.name, ascending: true)],
            predicate: NSPredicate(format: "id == %@", program.id as CVarArg)
        )
        self.color = uiThemeColors[program.color] ?? UIColor.systemBlue
    }

    @State private var showingNewAttendee = false
    @State private var isDirty = false
    @State private var confirmStop = false
    @State private var session = false

    let gridStyle = StaggeredGridStyle(
        tracks: .min(250),
        axis: .vertical,
        spacing: 16,
        padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
    )

    var body: some View {
        ZStack {
            Grid(self.fetchedResults.first!.attendeesArray) { attendee in
                AttendeeCard(attendee: attendee).environment(\.managedObjectContext, self.managedObjectContext)
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
                    NewAttendee(program: self.program).environment(\.managedObjectContext, self.managedObjectContext)
                })
            )
            .gridStyle(self.gridStyle)

            VStack(alignment: .center) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.session.toggle()
                        }
                    }) {
                        HStack(alignment: .center, spacing: 0) {
                            Image(systemName: self.session ? "stop.fill" : "play.fill")
                                .font(.system(size: 22))
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)

                            Text("Start New Session")
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.trailing, 28)
                                .frame(maxWidth: self.session ? 0 : 200, maxHeight: 28)
                                .clipped()
                                .animation(.spring(response: 0.0, dampingFraction: 0.2))
                        }
                        .background(self.session ? Color.red : Color.green)
                        .cornerRadius(.infinity)
                        .padding(20)
                        .shadow(color: self.session ? Color.red.opacity(0.5) : Color.green.opacity(0.5), radius: 12, x: 0, y: 6)
                        .animation(.easeInOut)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }.edgesIgnoringSafeArea(.all)
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
            Home(program: program).environment(\.managedObjectContext, context)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
