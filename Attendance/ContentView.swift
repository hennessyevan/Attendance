//
//  ContentView.swift
//  Attendance
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//
import SwiftUI

struct ContentView: View {    
    var body: some View {
        Programs()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
