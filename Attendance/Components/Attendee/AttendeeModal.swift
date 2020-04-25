//
//  AttendeeModal.swift
//  Attendance
//
//  Created by Evan Hennessy on 3/23/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

struct AttendeeModal: View {
    var attendee: Attendee

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("\(attendee.firstName!) \(attendee.lastName != nil ? attendee.lastName! : "")")
                        .font(.title)
                        .bold()
                    Text("Grade \(attendee.grade)")

                        .foregroundColor(.accentColor)
                }
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done").bold()
                }
            }.padding(24)
            Spacer()
            AttendeeModalFooter(attendee: attendee).environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

struct AttendeeModalFooter: View {
    var attendee: Attendee

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var confirmDelete = false

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.confirmDelete = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                .alert(isPresented: $confirmDelete) {
                    Alert(
                        title: Text("Are you sure you want to delete \(attendee.wrappedFirstName) \(attendee.wrappedLastName)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            self.managedObjectContext.delete(self.attendee)
                            try? self.managedObjectContext.save()

                            self.presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .foregroundColor(.red)
        }
        .padding()
    }
}

struct AttendeeModal_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let attendee = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
        attendee.firstName = "Evan"
        attendee.lastName = "Hennessy"
        attendee.grade = 10
        attendee.id = UUID()

        return HStack {
            Text("background")
        }
        .sheet(isPresented: .constant(true)) {
            AttendeeModal(
                attendee: attendee
            )
        }
        .environment(\.managedObjectContext, context)
    }
}
