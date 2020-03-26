//
//  ContentView.swift
//  YM Signup
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

class Session: ObservableObject {
    @Published var sessionName = ""
    @Published var focusID = UUID()
}

struct ContentView: View {
    @State private var selection = "Home"

    var body: some View {
        TabView(selection: $selection) {
            Home()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
                .tag("Home")
            AllAttendees()
                .tabItem {
                    VStack {
                        Image(systemName: "person.3")
                        Text("List")
                    }
                }
                .tag("AllAttendees")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
