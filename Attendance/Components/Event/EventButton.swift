//
//  EventButton.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/27/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

struct EventButton: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var toastIsPresenting = false
    @State private var confirmEnd = false

    var program: Program

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    if self.appState.currentEvent.isEmpty {
                        let event = Event(context: self.managedObjectContext)
                        let id = UUID()
                        event.createdAt = Date()
                        event.id = id
                        event.program = self.program

                        withAnimation {
                            self.appState.currentEvent = id.uuidString
                            self.toastIsPresenting = true
                        }

                        // Close toast after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.toastIsPresenting = false
                            }
                        }

                        try? self.managedObjectContext.save()
                    } else {
                        if !self.confirmEnd {
                            withAnimation {
                                self.confirmEnd = true
                            }
                        } else {
                            withAnimation {
                                self.confirmEnd = false
                                self.appState.currentEvent = ""
                                self.toastIsPresenting = false
                            }
                        }
                    }
                }) {
                    HStack(alignment: .center, spacing: 0) {
                        Image(systemName: appState.currentEvent.isEmpty ? "play.fill" : "stop.fill")
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)

                        Text(self.confirmEnd ? "End Event?" : "Start Event")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.trailing, 20)
                            .frame(maxWidth: appState.currentEvent.isEmpty || confirmEnd ? nil : 0, maxHeight: 28)
                            .animation(.spring(response: 0.0, dampingFraction: 0.2))
                    }
                    .background(appState.currentEvent.isEmpty ? Color.green : Color.red)
                    .cornerRadius(.infinity)
                    .padding(20)
                    .shadow(
                        color: appState.currentEvent.isEmpty ? Color.green.opacity(0.5) : Color.red.opacity(0.5),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
                    .animation(.easeInOut)
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }.toast(isPresenting: self.$toastIsPresenting, title: "Event Started")
    }
}

struct EventButton_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as!
            AppDelegate).persistentContainer.viewContext

        let program = NSEntityDescription.insertNewObject(forEntityName: "Program", into: context) as! Program
        program.name = "Lifeteen"
        program.id = UUID()
        program.color = "blue"

        return EventButton(program: program).environmentObject(AppState()).environment(\.managedObjectContext, context)
    }
}
