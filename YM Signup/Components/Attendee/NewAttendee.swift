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
    @Published var sex = 0

    var clean: Bool {
        if firstName.isEmpty || lastName.isEmpty {
            return true
        }
        return false
    }

    var dirty: Bool {
        return !clean
    }
}

struct NewAttendee: View {
    @Binding var isDirty: Bool
    var program: Program
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var fields = NewAttendeeFormFields()

    @State private var showCaptureImageView = false
    @State private var image: UIImage? = nil

    let grades: [Int32] = [6, 7, 8, 9, 10, 11, 12]

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image(uiImage: image ?? UIColor.systemGray3.image())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150, alignment: .center)
                        .cornerRadius(.infinity)

                    Button("Edit") {
                        self.showCaptureImageView = true
                    }
                }
                .onTapGesture {
                    self.showCaptureImageView = true
                }
                .padding(.top, 32)
                .frame(minWidth: 0, maxWidth: .infinity)

                Form {
                    TextField("First Name", text: self.$fields.firstName)
                    TextField("Last Name", text: self.$fields.lastName)

                    Picker(selection: self.$fields.grade, label: Text("Grade")) {
                        ForEach(0 ..< self.grades.count, id: \.self) {
                            Text("\(self.grades[$0])")
                        }
                    }

                    Picker(selection: self.$fields.sex, label: Text("Sex")) {
                        ForEach(Sex.keys.sorted(), id: \.self) {
                            Text(Sex[$0]!.capitalize())
                        }
                    }
                }.onReceive(self.fields.$firstName) { newFirstName in
                    if !newFirstName.isEmpty {
                        self.isDirty = true
                    } else {
                        self.isDirty = false
                    }
                }
                .onReceive(self.fields.$lastName) { newLastName in
                    if !newLastName.isEmpty {
                        self.isDirty = true
                    } else {
                        self.isDirty = false
                    }
                }
            }
            .sheet(isPresented: $showCaptureImageView) {
                CaptureImageView(isShown: self.$showCaptureImageView, image: self.$image)
                    .presentation(isModal: .constant(true))
            }
            .background(Color(UIColor.secondarySystemBackground))
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
                    attendee.sex = Int16(self.fields.sex)
                    attendee.id = UUID()
                    attendee.image = self.image?.jpegData(compressionQuality: 1.0)

                    try? self.managedObjectContext.save()
                    self.presentationMode.wrappedValue.dismiss()

                    let dataHelper = DataHelper(context: self.managedObjectContext)
                    dataHelper.printAllAttendees()

                         }) {
                    Text("Add")
                         }.disabled(fields.clean))
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
                    NewAttendee(isDirty: .constant(false), program: Program())
                }.padding()
            }
            Spacer()
        }
    }
}
