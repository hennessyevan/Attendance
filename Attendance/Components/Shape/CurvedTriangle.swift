//
//  CurvedTriangle.swift
//  Attendance
//
//  Created by Evan Hennessy on 9/2/20.
//  Copyright © 2020 Evan Hennessy. All rights reserved.
//

import SwiftUI

struct CurvedTriangle: Shape {
    func path(in rect: CGRect) -> Path{
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        path.move(to: CGPoint(x: 0.74888*width, y: 1.37494*height))
        path.addLine(to: CGPoint(x: 0.02452*width, y: 1.37494*height))
        path.addCurve(to: CGPoint(x: 0.17663*width, y: 1.23751*height),control1: CGPoint(x: 0.12337*width, y: 1.37494*height),control2: CGPoint(x: 0.17663*width, y: 1.23751*height))
        path.addCurve(to: CGPoint(x: 0.44594*width, y: 0.52723*height),control1: CGPoint(x: 0.17663*width, y: 1.23751*height),control2: CGPoint(x: 0.44594*width, y: 0.52723*height))
        path.addCurve(to: CGPoint(x: 0.47452*width, y: 0.50198*height),control1: CGPoint(x: 0.45187*width, y: 0.5116*height),control2: CGPoint(x: 0.46275*width, y: 0.50198*height))
        path.addCurve(to: CGPoint(x: 0.50309*width, y: 0.52723*height),control1: CGPoint(x: 0.48628*width, y: 0.50198*height),control2: CGPoint(x: 0.49717*width, y: 0.5116*height))
        path.addLine(to: CGPoint(x: 0.7724*width, y: 1.23751*height))
        path.addCurve(to: CGPoint(x: 0.92436*width, y: 1.37494*height),control1: CGPoint(x: 0.7724*width, y: 1.23751*height),control2: CGPoint(x: 0.82551*width, y: 1.37494*height))
        path.addCurve(to: CGPoint(x: 0.74888*width, y: 1.37494*height),control1: CGPoint(x: 0.92891*width, y: 1.37494*height),control2: CGPoint(x: 0.74888*width, y: 1.37494*height))
        path.closeSubpath()

        return path
    }
}

struct Curve_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CurvedTriangle()
                .fill(Color.black)
        }
        .previewLayout(.fixed(width: 400, height: 300))
    }
}
