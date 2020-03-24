//
//  PersonModal.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/23/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct PersonModal: View {
    
    var person: Attendee
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            HStack {
                Text("\(person.firstName!) \(person.lastName != nil ? person.lastName! : "")")
                    .font(.title)
                    .bold()
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
        PersonModal(person: Attendee())
    }
}
