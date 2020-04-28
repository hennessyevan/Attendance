//
//  ThemeColorPicker.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/20/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import Color
import SwiftUI
import UIKit

struct ThemeColor: Identifiable {
    var id = UUID()
    var key: String
    var value: Color
}

let uiThemeColors: [String: UIColor] = [
    "blue": .systemBlue,
    "red": .systemRed,
    "green": .systemGreen,
    "orange": .systemOrange,
    "purple": .systemPurple
]

let colorGradients: [String: Gradient] = [
    "blue": Gradient(colors: [
        Color(UIColor.systemBlue),
        Color(UIColor.systemBlue.saturating(by: 0.5).lightening(by: 0.2))
    ]),
    "red": Gradient(colors: [
        Color(UIColor.systemRed),
        Color(UIColor.systemRed.saturating(by: 0.5).lightening(by: 0.2))
    ]),
    "green": Gradient(colors: [
        Color(UIColor.systemGreen),
        Color(UIColor.systemGreen.saturating(by: 0.5).lightening(by: 0.2))
    ]),
    "orange": Gradient(colors: [
        Color(UIColor.systemOrange),
        Color(UIColor.systemOrange.saturating(by: 0.5).lightening(by: 0.2))
    ]),
    "purple": Gradient(colors: [
        Color(UIColor.systemPurple),
        Color(UIColor.systemPurple.saturating(by: 0.5).lightening(by: 0.2)
        )
    ])
]

let themeColors: [ThemeColor] = [
    ThemeColor(key: "blue", value: .blue),
    ThemeColor(key: "red", value: .red),
    ThemeColor(key: "green", value: .green),
    ThemeColor(key: "orange", value: .orange),
    ThemeColor(key: "purple", value: .purple)
]

struct ThemeColorPicker: View {
    var label: String?
    var themeColorsEnumerated = themeColors.enumerated().map { $0 }

    @Binding var selected: Int

    init(label: String? = nil, selected: Binding<Int>) {
        self.label = label
        self._selected = selected
    }

    init(colors: [ThemeColor] = themeColors, label: String? = nil, selected: Binding<Int>) {
        self.themeColorsEnumerated = colors.enumerated().map { $0 }
        self.label = label
        self._selected = selected
    }

    var body: some View {
        VStack(alignment: .leading) {
            if self.label != nil {
                Text(self.label!)
                    .bold()
            }
            HStack(spacing: 0) {
                ForEach(themeColorsEnumerated, id: \.element.id) { index, themeColor in
                    VStack {
                        if self.selected == index {
                            Circle().foregroundColor(themeColor.value).frame(width: 25, height: 25, alignment: .center)
                        } else {
                            Circle()
                                .stroke(themeColor.value, lineWidth: 3)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .frame(width: 25, height: 25)
                        }

                        Text(themeColor.key.capitalize())
                            .font(.subheadline)
                    }
                    .onTapGesture {
                        self.selected = index
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
        }
    }
}

struct ThemeColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ThemeColorPicker(label: "Label", selected: .constant(0))
    }
}
