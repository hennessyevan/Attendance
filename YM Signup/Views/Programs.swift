//
//  Programs.swift
//  YM Signup
//
//  Created by Evan Hennessy on 4/21/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import Grid
import SwiftUI

struct Programs: View {
    @ObservedObject var appState: AppState = .shared
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Program.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Program.name, ascending: true)]
    ) var programs: FetchedResults<Program>

    @State private var showingNewProgram = false

    let gridStyle = ModularGridStyle(
        columns: .min(150),
        rows: .fixed(200),
        spacing: 16,
        padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
    )

    var body: some View {
        NavigationView {
            Grid(programs) { program in
                ProgramCard(program: program)
            }
            .gridStyle(self.gridStyle)
            .navigationBarTitle("Programs")
            .navigationBarItems(trailing: Button(action: {
                self.showingNewProgram = true
                       }) {
                 Image(systemName: "plus.circle.fill").resizable().frame(width: 24, height: 24)
                                       .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0))
            }.sheet(isPresented: $showingNewProgram, content: {
                NewProgram()
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Programs_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Programs().environment(\.managedObjectContext, context)
    }
}
