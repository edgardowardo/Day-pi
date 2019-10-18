//
//  CoreGraphics+Extensions.swift
//  Day-pi
//
//  Created by EDGARDO AGNO on 17/10/2019.
//  Copyright © 2019 EDGARDO AGNO. All rights reserved.
//

import CoreGraphics

public extension CGRect {

    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2,
                             y: center.y - size.height / 2)
        self.init(origin: origin, size: size)
    }
}

extension CGSize {

    var diameter: CGFloat {
        return min(width, height)
    }

    var radius: CGFloat {
        return diameter / 2
    }

    var center: CGPoint {
        return .init(x: diameter / 2, y: diameter / 2)
    }
}
