//
//  PieView.swift
//  Day-pi
//
//  Created by EDGARDO AGNO on 15/10/2019.
//  Copyright © 2019 EDGARDO AGNO. All rights reserved.
//

import SwiftUI

struct PieShape: Shape {
    
    static let innermostRadiusRatio = 0.25
    static let innerRadiusRatio = 0.3
    let direction: Direction
    var ratio = 1.0
    
    func path(in rect: CGRect) -> Path {
        let radius = rect.size.radius
        let radiusInner = radius * 0.25
        let radiusOuter = radius * CGFloat(ratio)
        let center = rect.size.center
        let startArc = direction.startArc
        let startAngle = Angle(degrees: -startArc.degree)
        let endArc = direction.endArc
        let endAngle = Angle(degrees: -endArc.degree)

        var path = Path()

        // inner arc
        path.move(to: endArc.end(of: radiusInner, from: center))
        path.addArc(center: center,
                    radius: radiusInner,
                    startAngle: endAngle,
                    endAngle: startAngle,
                    clockwise: false)
        
        // line rightside from inner radius
        path.addLine(to: startArc.end(of: radiusOuter, from: center))
        
        // outer arc arc counter-clockwise
        path.addArc(center: center,
                    radius: radiusOuter,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        
        path.closeSubpath()
        return path
    }
    
    var animatableData: Double {
        get { return ratio }
        set { ratio = newValue }
    }
}

private extension CGSize {
    var innerDiameter: CGFloat {
        return diameter * CGFloat(PieShape.innermostRadiusRatio)
    }
}

struct PieView: View {
    let direction: Direction
    @State private var radiusRatio = PieShape.innerRadiusRatio
    @State private var duration = 0.5

  var body: some View {
    GeometryReader { geometry in
        Circle()
            .path(in: .init(center: geometry.center,
                            size: .init(width: geometry.size.innerDiameter,
                                        height: geometry.size.innerDiameter)))
            .stroke(lineWidth: 1)
            .foregroundColor(.gray)
        PieShape(direction: self.direction, ratio: self.radiusRatio)
            .fill(RadialGradient(gradient: Gradient(colors: [.orange, .red]),
                                 center: .center,
                                 startRadius: geometry.size.innerDiameter,
                                 endRadius: geometry.size.radius))
            .frame(width: geometry.size.diameter,
                   height: geometry.size.diameter)
            .animation(.easeInOut(duration: self.duration))
            .onAppear { self.radiusRatio = 1.0 }
            .onTapGesture { self.radiusRatio = self.radiusRatio == 1.0 ? PieShape.innerRadiusRatio : 1.0 }
        }
    }
}

struct PieView_Previews: PreviewProvider {
    static var previews: some View {
        PieView(direction: .north)
    }
}
