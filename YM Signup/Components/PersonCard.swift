//
//  PersonCard.swift
//  YM Signup
//
//  Created by Evan Hennessy on 2/5/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI
import CoreData

struct PersonCard: View {
    
    var person: Attendee
    
    let cornerRadius:CGFloat = 8
    
    @State private var show_modal: Bool = false
    @State private var offset = CGSize.zero
    @State var buttonShown = false
    @State private var rect: CGRect = CGRect()
    
    var body: some View {
        ZStack {
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
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(Color(UIColor.systemGray5))
        }
        .onTapGesture(perform: {
            if self.buttonShown {
                self.offset.width = .zero
                self.buttonShown = false
            } else {
                self.show_modal = true
            }
        })
        .offset(x: 0, y: 0)
        .offset(x: self.offset.width)
        .animation(.spring())
        .cornerRadius(cornerRadius)
        .sheet(isPresented: self.$show_modal, content: {
            PersonModal(person: self.person).animation(.spring())
        })
        .gesture(
            DragGesture()
                .onChanged { (value: DragGesture.Value) in
                    self.offset.width = value.translation.width
                    
                    if self.buttonShown {
                        self.offset.width += self.rect.width / 4
                    }
                    
                    if value.translation.width < 0 {
                        self.offset.width = 0
                    }
                    
                }
                .onEnded { value in
                        if self.offset.width > self.rect.width / 6 {
                            self.offset.width = self.rect.width / 4
                            self.buttonShown = true
                        } else {
                            self.offset = .zero
                            self.buttonShown = false
                        }
                }
            
        )
        .background(GeometryGetter(rect: $rect))
        .zIndex(1)
            
        Button(action: {
            
        }) {
            HStack {
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: rect.width / 16, height: rect.width / 16)
                Spacer()
            }
        }
        .frame(height: rect.height - 4, alignment: .center)
        .padding(.leading, rect.width / 16)
        .background(Color.green)
        .cornerRadius(cornerRadius)
        }
    }
}

struct PersonCard_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let person = NSEntityDescription.insertNewObject(forEntityName: "Attendee", into: context) as! Attendee
        person.firstName = "Evan"
        person.lastName = "Hennessy"
        person.grade = 10
        person.id = UUID()
        
        return HStack {
            PersonCard(
                person: person
            )
        }
        .environment(\.managedObjectContext, context)
        .padding()
    }
}
