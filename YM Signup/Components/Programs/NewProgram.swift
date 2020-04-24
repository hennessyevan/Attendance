//
//  NewProgram.swift
//  YM Signup
//
//  Created by Evan Hennessy on 4/22/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

class NewProgramFormFields: ObservableObject, PropertyNames {
    @Published var name = ""
    @Published var selectedColor = 0

    var invalid: Bool {
        if name.isEmpty {
            return true
        }
        return false
    }
}

struct NewProgram: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var fields = NewProgramFormFields()

    var body: some View {
        NavigationView {
            Form {
                TextField("Program name", text: $fields.name)
                Section {
                    ThemeColorPicker(label: "Color", selected: $fields.selectedColor).padding()
                }
            }
            .navigationBarTitle("New Program", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    
                },
                trailing: Button("Save") {
                let program = Program(context: self.managedObjectContext)
                program.name = self.fields.name
                program.color = themeColors[self.fields.selectedColor].key
                program.id = UUID()

                try? self.managedObjectContext.save()
                self.presentationMode.wrappedValue.dismiss()
            }.disabled(fields.invalid))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NewProgram_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            EmptyView()
        }.sheet(isPresented: .constant(true)) {
            NewProgram()
        }
    }
}
