//
//  PieView.swift
//  Day-pi
//
//  Created by EDGARDO AGNO on 15/10/2019.
//  Copyright © 2019 EDGARDO AGNO. All rights reserved.
//

import SwiftUI

struct PieShape: Shape {
    
    static let innerRadiusRatio = 0.3
    let direction: Direction
    var ratio = 1.0
    
    func path(in rect: CGRect) -> Path {
        let diameter: CGFloat = min(rect.width, rect.height)
        let radius = diameter / 2
        let radiusInner = radius * 0.25 //CGFloat(Self.innerRadiusRatio)
        let radiusOuter = radius * CGFloat(ratio)
        let center = CGPoint(x: diameter / 2 , y: diameter / 2)
        let startArc = direction.startArc
        let startAngle = Angle(degrees: -startArc.degree)
        let endArc = direction.endArc
        let endAngle = Angle(degrees: -endArc.degree)

        var path = Path()

        // inner arc
        path.move(to: endArc.end(of: radiusInner, from: center))
        path.addArc(center: center, radius: radiusInner, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        
        // line rightside from inner radius
        path.addLine(to: startArc.end(of: radiusOuter, from: center))
        
        // outer arc arc counter-clockwise
        path.addArc(center: center, radius: radiusOuter, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.closeSubpath()
        return path
    }
    
    var animatableData: Double {
        get { return ratio }
        set { ratio = newValue }
    }
}

struct CurrentView: View {
    @State private var radiusRatio = PieShape.innerRadiusRatio
    @State private var duration = 0.5

    var body: some View {
        PieShape(direction: .northEast, ratio: self.radiusRatio)
            .fill(Color.red)
            .animation(.easeInOut(duration: self.duration))
            .onTapGesture {
                self.radiusRatio = self.radiusRatio == 1.0 ? PieShape.innerRadiusRatio : 1.0
        }
    }
}

struct CurrentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentView()
    }
}
