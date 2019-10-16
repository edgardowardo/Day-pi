//
//  PieView.swift
//  Day-pi
//
//  Created by EDGARDO AGNO on 15/10/2019.
//  Copyright © 2019 EDGARDO AGNO. All rights reserved.
//

import SwiftUI

struct PieShape: Shape {
    let direction: Direction
    var radius = 0.0
    
    func path(in rect: CGRect) -> Path {
        let width: CGFloat = min(rect.width, rect.height)
        let center = CGPoint(x: width / 2 , y: width / 2)
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: self.direction.startArc.end(of: CGFloat(radius), from: center))
        let startAngle = Angle(degrees: -self.direction.startArc.degree)
        let endAngle = Angle(degrees: -self.direction.endArc.degree)
        path.addArc(center: center, radius: CGFloat(radius), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.closeSubpath()
        return path
    }
    
    var animatableData: Double {
        get { return radius }
        set { radius = newValue }
    }
}

struct CurrentView: View {
    @State private var radius: Double = 200.0
    @State private var duration: Double = 1.0

    var body: some View {
//        GeometryReader { geometry in
//            let width: CGFloat = min(geometry.size.width, geometry.size.height)
            PieShape(direction: .eastNorthEast, radius: self.radius)
                .fill(Color.red)
//                .stroke(Color.yellow, lineWidth: 3)
                .animation(.easeInOut(duration: self.duration))
                .onTapGesture {
                    self.radius = self.radius == 200 ? 10 : 200
            }
//        }
    }
}

struct CurrentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentView()
    }
}
