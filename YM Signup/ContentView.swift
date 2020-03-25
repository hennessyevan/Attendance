//
//  ContentView.swift
//  YM Signup
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI
import CoreData

class Session: ObservableObject {
    @Published var sessionName = ""
}

struct ContentView: View {
    let session = Session()
    @State private var selection = "Home"
    
    var body: some View {
        TabView(selection: $selection){
            Home()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
            }
            .tag("Home")
            List()
                .tabItem {
                    VStack {
                        Image(systemName: "person.3")
                        Text("List")
                    }
            }
            .tag("List")
            }.edgesIgnoringSafeArea(.top)
        .environmentObject(session)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
