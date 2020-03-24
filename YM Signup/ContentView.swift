//
//  ContentView.swift
//  YM Signup
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
