//
//  Programs.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/21/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

struct Programs: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Program.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Program.name, ascending: true)]
    ) var programs: FetchedResults<Program>

    @State private var showingNewProgram = false

    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 155, maximum: 155), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 0, pinnedViews: []) {
                    ForEach(programs) { program in
                        ProgramCard(program: program)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Programs")
            .configureNavigationBar {
                $0.navigationBar.tintColor = .systemBlue
                $0.navigationBar.barTintColor = .systemBackground
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Settings") {}
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {}
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewProgram = true }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showingNewProgram) {
                        NewProgram().environment(\.managedObjectContext, self.managedObjectContext)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
