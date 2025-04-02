//
//  Shapes.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 19/02/2025.
//

import Foundation
import SwiftUICore

struct CurvedBottonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let curveHeight: CGFloat = 20

        path.move(to: CGPoint(x: 0, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - curveHeight))

        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.maxY - curveHeight),
            control: CGPoint(x: rect.midX, y: rect.maxY + curveHeight)
        )
        path.addLine(to: CGPoint(x: 0, y: rect.minY))

        return path
    }

}
