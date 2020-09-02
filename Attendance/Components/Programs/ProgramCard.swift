//
//  ProgramCard.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/22/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

struct ProgramCard: View {
    @State private var tag: Int? = 0
    @State private var isLoading = false
    @EnvironmentObject var appState: AppState

    var program: Program
    var color: UIColor
    var gradient: Gradient

    private var opacity = 0.36

    init(program: Program) {
        self.program = program
        self.color = uiThemeColors[program.color]!
        self.gradient = colorGradients[program.color]!

        print(self.color)
    }
    
    func getSubline() -> String {
        if program.attendeesArray.count > 0 {
            return String("\(program.attendeesArray.count) members").uppercased()
        } else {
            return String("no members").uppercased()
        }
    }

    var body: some View {
        NavigationLink(destination: SingleProgram(program: program)) {
            Group {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        
                        Spacer()

                        Group {
                            Text(program.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .lineLimit(2)

                            Text(getSubline())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(LinearGradient(gradient: self.gradient, startPoint: .bottomTrailing, endPoint: .topLeading))
                .cornerRadius(8)
            }
        }
        .hoverEffect(.automatic)
        .shadow(color: Color(self.color).opacity(opacity), radius: 6, x: 0, y: 2)
        .frame(height: 215)
    }
}

#if DEBUG
struct ProgramCard_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let program = NSEntityDescription.insertNewObject(forEntityName: "Program", into: context) as! Program
        program.name = "Roman Catholic Initiation"
        program.color = "blue"
        program.id = UUID()

        let columns: [GridItem] = [
            GridItem(.fixed(145), spacing: 16)
        ]

        return LazyVGrid(columns: columns) {
            ForEach(0..<6) { _ in
                ProgramCard(program: program).environment(\.managedObjectContext, context)
                    .previewDevice("iPad Pro (11-inch)")
            }
        }
        .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
        .environmentObject(AppState())
    }
}
#endif
