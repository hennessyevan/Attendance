//
//  NewAttendee.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

class NewAttendeeFormFields: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var grade = 0

    var invalid: Bool {
        if firstName.isEmpty || lastName.isEmpty {
            return true
        }
        return false
    }
}

struct NewAttendee: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var fields = NewAttendeeFormFields()

    var program: Program

    let grades: [Int32] = [6, 7, 8, 9, 10, 11, 12]

    var body: some View {
        NavigationView {
            Form {
                TextField("First Name", text: self.$fields.firstName)
                TextField("Last Name", text: self.$fields.lastName)

                Picker(selection: self.$fields.grade, label: Text("Grade")) {
                    ForEach(0 ..< self.grades.count, id: \.self) {
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
                    attendee.firstName = self.fields.firstName
                    attendee.lastName = self.fields.lastName
                    attendee.addToPrograms(self.program)
                    attendee.grade = self.grades[self.fields.grade]
                    attendee.id = UUID()

                    try? self.managedObjectContext.save()
                    self.presentationMode.wrappedValue.dismiss()
                    
                    let dataHelper = DataHelper(context: self.managedObjectContext)
                    dataHelper.printAllAttendees()

                }) {
                    Text("Add")
                }.disabled(fields.invalid))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NewAttendee_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                Text("").sheet(isPresented: .constant(true)) {
                    NewAttendee(program: Program())
                }.padding()
            }
            Spacer()
        }
    }
}
