//
//  NewAttendee.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct NewAttendee: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var grade = 0

    let grades: [Int32] = [6, 7, 8, 9, 10, 11, 12]

    var body: some View {
        NavigationView {
            Form {
                TextField("First Name", text: self.$firstName)
                TextField("Last Name", text: self.$lastName)

                Picker(selection: self.$grade, label: Text("Grade")) {
                    ForEach(0 ..< self.grades.count) {
                        Text("\(self.grades[$0])")
                    }
                }
            }
            .navigationBarTitle("New Attendee", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    let attendee = Attendee(context: self.managedObjectContext)
                    attendee.firstName = self.firstName
                    attendee.lastName = self.lastName
                    attendee.grade = self.grades[self.grade]
                    attendee.id = UUID()

                    try? self.managedObjectContext.save()
                    self.presentationMode.wrappedValue.dismiss()

                }) {
                    Text("Add")
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NewAttendee_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                Text("Test").sheet(isPresented: .constant(true)) {
                    NewAttendee()
                }.padding()
            }
            Spacer()
        }
    }
}
