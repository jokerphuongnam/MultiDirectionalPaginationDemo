//
//  MultiDirectionalPagination+Drag.swift
//  DemoPager
//
//  Created by gannha on 20/04/2022.
//

import SwiftUI

extension MultiDirectionalPagination {
    static func dampen(_ value: CGFloat, range: ClosedRange<CGFloat>, spring: CGFloat = 12) -> CGFloat {
        if range.contains(value) {
            return value
        } else if value > range.upperBound {
            let change = value - range.upperBound
            let x = pow(M_E, Double(change) / Double(spring))
            return -(2 * spring) / CGFloat(1 + x) + spring + range.upperBound
        } else {
            let change = value - range.lowerBound
            let x = pow(M_E, Double(change) / Double(spring))
            return -(2 * spring) / CGFloat(1 + x) + spring + range.lowerBound
        }
    }
    
    static func closest(_ mark: CGFloat, markers: [CGFloat]) -> CGFloat {
        let first = markers.first!
        return markers.reduce(
            (first, abs(first - mark))
        ) { (current, value) -> (CGFloat, CGFloat) in
            if current.1 > abs(value - mark) {
                return (value, abs(value - mark))
            }
            return current
        }.0
    }
    
    static func orientationDrag(with value: DragGesture.Value) -> Orienttaion? {
        let start = value.startLocation
        let current = value.location
        let rangeX = abs(current.x - start.x)
        let rangeY = abs(current.y - start.y)
        if rangeX > rangeY {
            return .horizotal
        } else if rangeX < rangeY {
            return .vertical
        }
        return nil
    }
}
