//
//  Image+Extensions.swift
//  Attendance
//
//  Created by Evan Hennessy on 4/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

extension Image {
    func waitForImage(image: Binding<UIImage?>) -> some View {
        ModifiedContent(content: self, modifier: PlaceholderImageModifier(image: image))
    }
}

struct PlaceholderImageModifier: ViewModifier {
    @Binding var image: UIImage?
    
    func body(content: Content) -> some View {
        if image != nil {
            return Image(uiImage: image!)
            .resizable()
            .eraseToAnyView()
        }
        
        return content.eraseToAnyView()
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
