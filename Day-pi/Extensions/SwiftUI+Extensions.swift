//
//  SwiftUI+Extensions.swift
//  Day-pi
//
//  Created by EDGARDO AGNO on 17/10/2019.
//  Copyright © 2019 EDGARDO AGNO. All rights reserved.
//

import SwiftUI

public extension GeometryProxy {
    var center: CGPoint {
        return CGPoint(x: size.width/2, y: size.width/2)
    }
}
