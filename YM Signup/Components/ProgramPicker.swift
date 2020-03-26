//
//  ProgramPicker.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/25/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct ProgramPicker: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Program.entity(),
        sortDescriptors: []
    ) var programs: FetchedResults<Program>

    @State private var newProgramIsShown = false

    var body: some View {
        NavigationView {
            List(1..<5) { _ in
                Text("Test")
            }
            .navigationBarTitle("Programs", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(
                destination: Text("Add Program").navigationBarTitle("New Program"))
            {
                Text("Add")
                    .alert(isPresented: $newProgramIsShown) {
                        Alert(title: Text("Alert"), message: Text("message"), dismissButton: .default(Text("OK")))
                    }
            })
        }
        .frame(minWidth: 400, idealWidth: 500, maxWidth: 600, minHeight: 400, idealHeight: 500, maxHeight: 600, alignment: .topLeading)
    }
}

struct ProgramPicker_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Button(action: {}) {
            EmptyView()
        }.popover(isPresented: .constant(true)) {
            ProgramPicker().environment(\.managedObjectContext, context)
        }
    }
}
