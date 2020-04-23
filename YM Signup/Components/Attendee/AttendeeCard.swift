//
//  AttendeeCard.swift
//  YM Signup
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SwiftUI

struct AttendeeCard: View {
    var attendee: Attendee
    
    let cornerRadius: CGFloat = 8
    
    @State private var show_modal: Bool = false
    @GestureState private var isPressing = false
    @State private var isPressed = false
    @State var buttonShown = false
    @State private var rect: CGRect = CGRect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(attendee.firstName!)")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                        
                        if attendee.lastName != nil {
                            Text("\(attendee.lastName!)")
                                .fontWeight(.bold)
                                .font(.system(size: 18))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Text("Grade \(attendee.grade)")
                        .font(.system(size: 14))
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(Color(UIColor.systemGray5))
        }
        .onLongPressGesture {
            self.show_modal = true
        }
        .cornerRadius(cornerRadius)
        .sheet(isPresented: self.$show_modal) {
            AttendeeModal(attendee: self.attendee).animation(.spring())
        }
    }
}

struct AttendeeCard_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let attendee = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
        attendee.firstName = "Evan"
        attendee.lastName = "Hennessy"
        attendee.grade = 10
        attendee.id = UUID()
        
        return HStack {
            AttendeeCard(
                attendee: attendee
            )
        }
        .environment(\.managedObjectContext, context)
        .padding()
    }
}
