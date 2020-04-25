//
//  ProgramCard.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/22/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import Grid
import SwiftUI

struct ProgramCard: View {
    @ObservedObject var appState: AppState = .shared

    @State private var tag: Int? = 0

    var program: Program
    var color: Color?

    private var opacity = 0.24

    init(program: Program) {
        self.program = program
        self.color = themeColors.first(where: { $0.key == program.wrappedColor })?.value
    }

    var body: some View {
        Button(action: {}) {
            Group {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Spacer()
                        NavigationLink(destination: Home(program: program).navigationBarBackButtonHidden(true), tag: 1, selection: $tag) { EmptyView() }
                        Group {
                            Text(program.wrappedName)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .lineLimit(2)

                            Text(String("\(program.attendeesArray.count) members").uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(color)
                .cornerRadius(8)
                .shadow(color: color?.opacity(opacity) ?? Color.gray.opacity(opacity), radius: 6, x: 0, y: 2)
            }
            .onTapGesture {
                self.tag = 1
            }
        }
        .buttonStyle(ScaleButtonStyle(scaleAmount: 0.95))
        .frame(minWidth: 75, maxWidth: 165, minHeight: 100, maxHeight: 215)
    }
}

struct ProgramCard_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let program = NSEntityDescription.insertNewObject(forEntityName: "Program", into: context) as! Program
        program.name = "Roman Catholic Initiation"
        program.color = "blue"
        program.id = UUID()

        return Grid(0..<6) { _ in
            ProgramCard(program: program).environment(\.managedObjectContext, context)
                .previewDevice("iPad Pro (11-inch)")
        }.gridStyle(ModularGridStyle(
            columns: .min(165),
            rows: .fixed(215),
            spacing: 16,
            padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
        )).previewDevice("iPad Pro (11-inch)")
    }
}
