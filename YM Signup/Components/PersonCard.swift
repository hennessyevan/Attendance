//
//  PersonCard.swift
//  YM Signup
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct PersonCard: View {
    
    var person: Attendee
    var cornerRadius:CGFloat = 8
    
    @State private var show_modal: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    HStack {
                    Text("\(person.firstName!)")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                        
                    if person.lastName != nil {
                        Text("\(person.lastName!)")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                        }
                    }
                    
                    Text("Grade \(person.grade)")
                        .font(.system(size: 14))
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 24)
            .background(Color(UIColor.systemGray5))
        }
        .onTapGesture(perform: {
            self.show_modal = true
        })
        .cornerRadius(cornerRadius)
        .sheet(isPresented: self.$show_modal, content: {
            PersonModal(person: self.person).animation(.spring())
        })
    }
}

struct PersonCard_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return PersonCard(person: Attendee.init(context: context)).environment(\.managedObjectContext, context)
    }
}
