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
    }

    var body: some View {
        Button(action: {}) {
            Group {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        ActivityIndicator(isAnimating: self.$isLoading, style: .medium)

                        Spacer()

                        NavigationLink(destination: Home(program: program).navigationBarBackButtonHidden(true), tag: 1, selection: $tag) { EmptyView() }
                        Group {
                            Text(program.name)
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
                .background(LinearGradient(gradient: self.gradient, startPoint: .bottomTrailing, endPoint: .topLeading))
                .cornerRadius(8)
            }
            .onTapGesture {
                self.isLoading = true

                self.tag = 1
            }
        }
        .onDisappear {
            self.isLoading = false
        }
        .shadow(color: Color(self.color).opacity(opacity), radius: 6, x: 0, y: 2)
        .buttonStyle(ScaleButtonStyle(scaleAmount: 0.95))
        .frame(width: 155, height: 215)
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

        return Grid(0..<6) { _ in
            ProgramCard(program: program).environment(\.managedObjectContext, context)
                .previewDevice("iPad Pro (11-inch)")
        }
        .gridStyle(ModularGridStyle(.vertical, columns: .min(155), rows: .fixed(215), spacing: 16))
        .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
        .environmentObject(AppState())
    }
}
#endif
