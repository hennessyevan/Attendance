//
//  ProgramBar.swift
//  Attendance
//
//  Created by Evan Hennessy on 9/2/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

let circleSize: CGFloat = 48

struct Action: Identifiable {
    var id = UUID()

    var title: String
    var action: () -> Void
    var icon: String = "questionmark"
}

struct Filter: Identifiable {
    var id = UUID()
    var title: String
    var alwaysShow: Bool?
    var property: String?
}

var filters: [Filter] = [
    Filter(title: "All", alwaysShow: true),
    Filter(title: "Signed In"),
    Filter(title: "Signed Out")
]

struct ProgramBar: View {
    var program: Program
    var color: UIColor
    var showProgramBar: Bool

    let actions = [
        Action(title: "Group", action: {}, icon: "person.3.fill")
    ]

    @Namespace var filterNamespace
    @State var activeFilter: UUID = filters[0].id

    init(program: Program, color: UIColor, showProgramBar: Bool) {
        self.program = program
        self.color = color
        self.showProgramBar = showProgramBar
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if showProgramBar {
                HStack {
                    ForEach(actions) { action in
                        ProgramAction(action: action)
                    }
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
            }

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()

                    HStack(alignment: .center, spacing: 32) {
                        ForEach(filters) { filter in
                            FilterButton(filter: filter, program: program, namespace: filterNamespace, activeFilter: $activeFilter)
                        }
                    }

                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: 512)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .accentColor(Color(color))
    }
}

struct ProgramAction: View {
    var action: Action

    var body: some View {
        Button(action: action.action) {
            VStack {
                ZStack {
                    Circle()
                        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 1, x: 0, y: 1)
                        .frame(width: circleSize, height: circleSize)
                        .foregroundColor(Color(UIColor.systemBackground))
                    Image(systemName: action.icon)
                }
                Text(action.title)
            }
        }
    }
}

struct FilterButton: View {
    var filter: Filter
    var program: Program
    var namespace: Namespace.ID
    @Binding var activeFilter: UUID

    var active: Bool { activeFilter == filter.id }

    var body: some View {
        Button(action: {
            if !active {
                withAnimation {
                    activeFilter = filter.id
                }
            }
        }) {
            VStack(alignment: .center, spacing: 4) {
                HStack(alignment: .center, spacing: 0) {
                    if program.attendeesArray.count <= 0 {
                        Avatar(image: UIImage(systemName: "person.crop.circle.fill"))
                    } else {
                        ForEach(0..<min(3, program.attendeesArray.count)) { index in
                            Avatar(image: program.attendeesArray[index].image != nil ? UIImage(data: program.attendeesArray[index].image!) : nil)
                                .zIndex(10.0 - Double(index))
                        }
                    }
                }
                Text(filter.title)
                    .foregroundColor(Color(UIColor.label))

                if active {
                    CurvedTriangle()
                        .fill(Color(UIColor.systemBackground))
                        .frame(width: 40, height: 24)
                        .padding(.top, -10)
                        .matchedGeometryEffect(id: "triangle", in: namespace)
                } else {
                    HStack {}.frame(width: 26, height: 14)
                }
            }
        }
        .padding(.top)
        .padding(.horizontal)
        .buttonStyle(ScaleButtonStyle())
    }
}

struct Avatar: View {
    var image: UIImage?

    var body: some View {
        if image != nil {
            Circle()
                .strokeBorder(Color(UIColor.systemGray6), lineWidth: 2)
                .background(
                    Image(uiImage: image!).resizable().scaledToFill().clipShape(Circle())
                )
                .frame(width: circleSize, height: circleSize)
                .padding(.horizontal, -14)
        } else {
            Circle()
                .strokeBorder(Color(UIColor.systemGray6), lineWidth: 2)
                .background(Circle().foregroundColor(Color.gray))
                .frame(width: circleSize, height: circleSize)
                .padding(.horizontal, -14)
        }
    }
}

struct ProgramBar_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as!
            AppDelegate).persistentContainer.viewContext

        let program = NSEntityDescription.insertNewObject(forEntityName: "Program", into: context) as! Program
        program.name = "Lifeteen"
        program.id = UUID()
        program.color = "red"

        for _ in 0..<5 {
            let attendee = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
            attendee.firstName = "Evan"
            attendee.lastName = "Hennessy"
            attendee.addToPrograms(program)
            attendee.grade = 10
            attendee.id = UUID()
            attendee.image = UIImage(named: String(Int.random(in: 0...2)))!.jpegData(compressionQuality: 1.0)
        }

        let color = uiThemeColors[program.color] ?? UIColor.systemBlue

        return ProgramBar(program: program, color: color, showProgramBar: true)
            .previewDevice("iPad Pro (11-inch) (2nd generation)")
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState())
    }
}
