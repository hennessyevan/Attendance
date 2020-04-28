//
//  NewAttendee.swift
//  Attendance
//
//  Created by Evan Hennessy on 3/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import Combine
import SwiftUI

class NewAttendeeFormFields: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var grade = 0
    @Published var sex = 0
    @Published var image: UIImage? = nil

    @Published var clean = true
    @Published var dirty = false

    var subscribers = Set<AnyCancellable>()

    init() {
        $firstName.combineLatest($lastName, $image).map { firstName, lastName, image in
            if firstName.isEmpty, lastName.isEmpty, image == nil {
                return true
            }

            return false
        }
        .assign(to: \.clean, on: self)
        .store(in: &subscribers)

        $clean.map { !$0 }.assign(to: \.dirty, on: self).store(in: &subscribers)
    }
}

struct NewAttendee: View {
    var program: Program

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var fields = NewAttendeeFormFields()

    @State private var showCaptureImageView = false

    let grades: [Int32] = [6, 7, 8, 9, 10, 11, 12]

    var body: some View {
        NavigationView {
            Form {
                VStack {
                    if self.fields.image == nil {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 150))
                            .frame(width: 150, height: 150, alignment: .center)
                            .cornerRadius(.infinity)
                            .onTapGesture {
                                self.showCaptureImageView = true
                            }
                    } else {
                        Image(uiImage: self.fields.image!)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150, alignment: .center)
                            .cornerRadius(.infinity)
                    }

                    Button(self.fields.image == nil ? "Add Photo" : "Edit") {
                        self.showCaptureImageView = true
                    }
                }
                .padding(.vertical, 32)
                .frame(minWidth: 0, maxWidth: .infinity)

                TextField("First Name", text: self.$fields.firstName).tag(0)
                TextField("Last Name", text: self.$fields.lastName).tag(1)

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
                    attendee.sex = Int16(self.fields.sex)
                    attendee.id = UUID()
                    attendee.image = self.fields.image?.jpegData(compressionQuality: 1.0)

                    try? self.managedObjectContext.save()
                    self.presentationMode.wrappedValue.dismiss()

                }) {
                    Text("Done").fontWeight(.semibold)
                }.disabled(self.fields.clean)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .presentation(isModal: self.$fields.dirty)
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
}
