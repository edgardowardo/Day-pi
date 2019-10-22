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
    @State private var animate = false

    let gradient1: [UIColor] = [.blue, .green]
    let gradient2: [UIColor] = [.red, .yellow]
        
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Circle()
                    .path(in: .init(center: geometry.center,
                                    size: .init(width: geometry.size.innerDiameter,
                                                height: geometry.size.innerDiameter)))
                    .stroke(lineWidth: 1)
                    .foregroundColor(.gray)
                Color
                    .clear
                    .frame(width: geometry.size.diameter,
                           height: geometry.size.diameter)
                    .overlay(Color.clear.modifier(RadialAnimatableGradient(from: self.gradient1, to: self.gradient2, pct: self.animate ? 1 : 0)))
                    .clipShape(PieShape(direction: self.direction, ratio: self.radiusRatio))
                    .onAppear {
                        withAnimation(Animation.default) {
                            self.radiusRatio = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(Animation.default.speed(0.2).repeatForever(autoreverses: true)) {
                                self.animate.toggle()
                            }
                        }
                    }
                    .onTapGesture { self.radiusRatio = self.radiusRatio == 1.0 ? PieShape.innerRadiusRatio : 1.0 }
            }
            
            Button("Toggle Gradient") {
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.animate.toggle()
                }
            }
        }.navigationBarTitle("Wind Times")
    }
}

struct PieView_Previews: PreviewProvider {
    static var previews: some View {
        PieView(direction: .north)
    }
}

struct RadialAnimatableGradient: AnimatableModifier {
    let from: [UIColor]
    let to: [UIColor]
    var pct: CGFloat = 0
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        var gColors = [Color]()
        
        for i in 0..<from.count {
            gColors.append(colorMixer(c1: from[i], c2: to[i], pct: pct))
        }
        
        return
            GeometryReader { geometry in
                Rectangle()
                .fill(RadialGradient(gradient: Gradient(colors: gColors),
                                     center: .center,
                                     startRadius: .zero,
                                     endRadius: geometry.size.radius))
        }
    }
    
    // This is a very basic implementation of a color interpolation
    // between two values.
    func colorMixer(c1: UIColor, c2: UIColor, pct: CGFloat) -> Color {
        guard let cc1 = c1.cgColor.components else { return Color(c1) }
        guard let cc2 = c2.cgColor.components else { return Color(c1) }
        
        let r = (cc1[0] + (cc2[0] - cc1[0]) * pct)
        let g = (cc1[1] + (cc2[1] - cc1[1]) * pct)
        let b = (cc1[2] + (cc2[2] - cc1[2]) * pct)

        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
}
