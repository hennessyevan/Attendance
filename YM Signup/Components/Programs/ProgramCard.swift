//
//  ProgramCard.swift
//  YM Signup
//
//  Created by Evan Hennessy on 4/22/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import Grid
import SwiftUI

struct ProgramCard: View {
    @ObservedObject var appState: AppState = .shared

    var program: Program
    var color: Color?

    init(program: Program) {
        self.program = program
        self.color = themeColors.first(where: { $0.key == program.wrappedColor })?.value
    }

    var body: some View {
        NavigationLink(destination:
            Home(program: program).navigationBarBackButtonHidden(true)
        ) {
            HStack(alignment: .top) {
                Text(program.wrappedName)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(minWidth: 75, maxWidth: 150, minHeight: 100, maxHeight: 200)
            .padding()
            .background(color)
            .cornerRadius(8)
        }
    }
}

struct ProgramCard_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let program = NSEntityDescription.insertNewObject(forEntityName: "Program", into: context) as! Program
        program.name = "Lifeteen"
        program.color = "blue"
        program.id = UUID()

        return Grid(0..<6) { _ in
            ProgramCard(program: program).environment(\.managedObjectContext, context)
        }.gridStyle(ModularGridStyle(
            columns: .min(150),
            rows: .fixed(200),
            spacing: 16,
            padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
        ))
    }
}
