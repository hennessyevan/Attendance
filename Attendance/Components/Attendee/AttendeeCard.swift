//
//  AttendeeCard.swift
//  Attendance
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import CoreData
import SimpleHaptics
import SwiftUI

struct AttendeeCard: View {
    var attendee: Attendee
    var currentEventID: String
    
    let cornerRadius: CGFloat = 8
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject private var haptics: SimpleHapticGenerator
    @EnvironmentObject private var appState: AppState
    
    @State private var show_modal: Bool = false
    
    var eventFetchRequest: FetchRequest<Event>
    var currentEvent: Event? { eventFetchRequest.wrappedValue.first }
    
    init(attendee: Attendee, currentEventID: String) {
        self.attendee = attendee
        self.eventFetchRequest = FetchRequest(
            entity: Event.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", currentEventID.isEmpty ? UUID() as CVarArg : UUID(uuidString: currentEventID)! as CVarArg)
        )
        self.currentEventID = currentEventID
    }
    
    func attendeeIsChecked(attendee: Attendee, currentEvent: Event?) -> Bool {
        if currentEvent != nil && currentEvent!.attendeesArray.contains(attendee) {
            return true
        }
        
        return false
    }
    
    var body: some View {
        Button(action: {
            // EMPTY
        }) {
            Group {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(attendee.firstName)")
                                    .fontWeight(.bold)
                                    .font(.system(size: 18))
                                    .foregroundColor(.primary)
                                
                                Text("\(attendee.lastName)")
                                    .fontWeight(.bold)
                                    .font(.system(size: 18))
                                    .foregroundColor(.primary)
                            }
                            
                            Text("Grade \(attendee.grade)")
                                .font(.system(size: 14))
                                .foregroundColor(.accentColor)
                        }
                        Spacer()
                        
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color(UIColor.systemGray2))
                            .frame(width: 25, height: 25)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .background(attendeeIsChecked(attendee: attendee, currentEvent: currentEvent) ? Color.green : Color(UIColor.systemGray5))
                }
            }
            .onTapGesture {
                if self.currentEvent == nil { return }
                    
                if self.currentEvent!.attendeesArray.contains(self.attendee) {
                    self.currentEvent!.removeFromAttendees(self.attendee)
                } else {
                    self.currentEvent!.addToAttendees(self.attendee)
                }
                try? self.managedObjectContext.save()
            }
            .onLongPressGesture {
                try? self.haptics.fire(intensity: 1, sharpness: 1)
                
                self.show_modal = true
            }
        }
        .disabled(appState.currentEvent.isEmpty)
        .buttonStyle(ScaleButtonStyle(scaleAmount: 0.95))
        .cornerRadius(cornerRadius)
        .sheet(isPresented: self.$show_modal) {
            AttendeeModal(attendee: self.attendee)
                .animation(.spring())
                .environment(\.managedObjectContext, self.managedObjectContext)
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
                attendee: attendee,
                currentEventID: ""
            )
        }
        .environment(\.managedObjectContext, context)
        .padding()
    }
}
