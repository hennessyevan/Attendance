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
    @FetchRequest(
        entity: Attendee.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Attendee.firstName, ascending: true)]
    ) var attendees: FetchedResults<Attendee>

    @ObservedObject var session = Session()
    @State private var showingNewAttendee = false
    @State private var showingProgramPopover = false

    let gridStyle = StaggeredGridStyle(
        tracks: .min(250),
        axis: .vertical,
        spacing: 16,
        padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
    )

    var body: some View {
        NavigationView {
            Grid(attendees) { attendee in
                PersonCard(person: attendee)
            }
            .navigationBarTitle(session.sessionName == "" ? "Home" : session.sessionName)
            .navigationBarItems(
                leading:
                Button(action: {
                    self.showingProgramPopover = true
                }) {
                    Text("Programs")
                }.popover(isPresented: $showingProgramPopover) {
                    ProgramPicker().environment(\.managedObjectContext, self.managedObjectContext)
                },
                trailing:
                Button(action: {
                    self.showingNewAttendee = true
                }) {
                    Image(systemName: "plus.circle.fill").resizable().frame(width: 24, height: 24)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0))
                }.sheet(isPresented: $showingNewAttendee, content: {
                    NewAttendee().environment(\.managedObjectContext, self.managedObjectContext)
                })
            )
            .gridStyle(self.gridStyle)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = Session()
        session.sessionName = "Lifeteen"
        return Home().environment(\.managedObjectContext, context).environmentObject(session)
    }
}
