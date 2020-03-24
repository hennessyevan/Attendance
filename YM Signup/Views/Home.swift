//
//  Home.swift
//  YM Signup
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI
import Grid
import CoreData


struct Home: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Attendee.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Attendee.firstName, ascending: true)]
    ) var attendees: FetchedResults<Attendee>

    
    let gridStyle = StaggeredGridStyle(
        tracks: .min(250),
        axis: .vertical,
        spacing: 16,
        padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16)
    )
    
    var body: some View {
        NavigationView {
            Grid(attendees) { attendee in
                PersonCard(person: attendee)
            }
            .navigationBarTitle("Home")
            .gridStyle(self.gridStyle)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Home().environment(\.managedObjectContext, context)
    }
}
#endif
