//
//  ComparableExtension.swift
//  HelloColor
//
//  Created by Alex Shepard on 6/9/22.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
