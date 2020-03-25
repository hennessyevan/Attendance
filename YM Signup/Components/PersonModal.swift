//
//  PersonModal.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/23/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI
import CoreData

struct PersonModal: View {
    
    var person: Attendee
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("\(person.firstName!) \(person.lastName != nil ? person.lastName! : "")")
                        .font(.title)
                        .bold()
                    Text("Grade \(person.grade)")
                        
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
        }
    }
}

struct PersonModal_Previews: PreviewProvider {
      static var previews: some View {
          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          let person = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
          person.firstName = "Evan"
          person.lastName = "Hennessy"
          person.grade = 10
          person.id = UUID()
          
          return HStack {
              PersonModal(
                  person: person
              )
          }
          .environment(\.managedObjectContext, context)
      }
}
