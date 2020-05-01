//
//  Programs.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/21/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import Grid
import SwiftUI

struct Programs: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Program.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Program.name, ascending: true)]
    ) var programs: FetchedResults<Program>

    @State private var showingNewProgram = false

    let gridStyle = ModularGridStyle(
        .vertical,
        columns: .min(155),
        rows: .fixed(215),
        spacing: 16
    )

    var body: some View {
        NavigationView {
            ScrollView {
                Grid(programs) { program in
                    ProgramCard(program: program)
                }
                .gridStyle(self.gridStyle)
                .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
                .navigationBarTitle("Programs")
                .navigationBarItems(trailing: Button(action: {
                    self.showingNewProgram = true
                       }) {
                    Image(systemName: "plus.circle.fill").font(.system(size: 22))
                }.sheet(isPresented: $showingNewProgram, content: {
                    NewProgram()
                        .environment(\.managedObjectContext, self.managedObjectContext)
                })
                )
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct Programs_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Programs().environment(\.managedObjectContext, context)
    }
}
#endif
