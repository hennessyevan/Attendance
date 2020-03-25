//
//  GeometryGetter.swift
//  YM Signup
//
//  Created by Evan Hennessy on 3/24/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }

    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}
