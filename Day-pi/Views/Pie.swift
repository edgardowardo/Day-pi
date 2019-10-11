//
//  Pie.swift
//  Day-pi
//
//  Created by EDGARDO AGNO on 10/10/2019.
//  Copyright © 2019 EDGARDO AGNO. All rights reserved.
//

import SwiftUI

struct Pie: View {
    let direction: Direction
    let scale: Double
    let radiusRatio: Double = 1
    
    init(_ direction: Direction) {
        self.direction = direction
        self.scale = 0.8
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width: CGFloat = min(geometry.size.width, geometry.size.height)
                let radius = width / 2 * CGFloat(self.scale * self.radiusRatio)
                let center = CGPoint(x: width / 2 , y: width / 2)
                path.move(to: center)
                path.addLine(to: self.direction.startArc.end(of: radius, from: center))
                let startAngle = Angle(degrees: -self.direction.startArc.degree)
                let endAngle = Angle(degrees: -self.direction.endArc.degree)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                path.addLine(to: center)
            }
            .fill(Color.orange)
        }
    }
}

struct Pie_Previews: PreviewProvider {
    static var previews: some View {
        Pie(.southEast)
    }
}
