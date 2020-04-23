//
//  AttendeeModal.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/23/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

struct AttendeeModal: View {
    var attendee: Attendee

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
            AttendeeModalFooter(attendee: attendee)
        }
    }
}

struct AttendeeModalFooter: View {
    var attendee: Attendee
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete")
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
