//
//  NewAttendee.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct NewAttendee: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {
        Form {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
        }
    }
}

struct NewAttendee_Previews: PreviewProvider {
    static var previews: some View {
        NewAttendee()
    }
}
