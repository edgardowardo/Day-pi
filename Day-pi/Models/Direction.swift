//
//  Direction.swift
//  Day-pi
//
//  Created by EDGARDO AGNO on 10/10/2019.
//  Copyright © 2019 EDGARDO AGNO. All rights reserved.
//

import SwiftUI

enum Direction: Int, CaseIterable {
    case east
    case eastNorthEast
    case northEast
    case northNorthEast
    case north
    case northNorthWest
    case northWest
    case westNorthWest
    case west
    case westSouthWest
    case southWest
    case southSouthWest
    case south
    case southSouthEast
    case southEast
    case eastSouthEast
}

extension Direction {
    var degree: Double {
        return Double(self.rawValue) * oneOfSixteenthDegree
    }
    
    func end(of radius: CGFloat, from center: CGPoint) -> CGPoint {
        let bearing = -CGFloat(self.degree) * .pi / 180
        let x = center.x + radius * cos(bearing)
        let y = center.y + radius * sin(bearing)
        return CGPoint(x: x, y: y)
    }
    
    /// Arc drawing is clockwise hence subtract by an index from start. Except on the edge cases of east and eastSouthEast.
    var startArc: Direction {
        guard self != .east
            else { return .eastSouthEast}
        return Direction(rawValue: self.rawValue - 1)!
    }

    /// Arc drawing is clockwise hence add an index to end. Except on the edge cases of east and eastSouthEast.
    var endArc: Direction {
        guard self != .eastSouthEast
            else { return .east }
        return Direction(rawValue: self.rawValue + 1)!
    }
}

fileprivate let oneOfSixteenthDegree = 22.5
