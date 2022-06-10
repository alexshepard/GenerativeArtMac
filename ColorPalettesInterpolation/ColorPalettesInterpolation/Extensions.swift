//
//  Extensions.swift
//  ColorPalettesInterpolation
//
//  Created by Alex Shepard on 6/10/22.
//

import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
    public typealias OSColor = UIColor
#elseif os(OSX)
    import Cocoa
    public typealias OSColor = NSColor
#endif


extension Color {
    func getHSB() -> (Double, Double, Double) {
        let osColor = OSColor(self)
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        osColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (hue, saturation, brightness)
    }
    
    func lerp(otherColor: Color, interpolationStyle: InterpolationStyle, amount: Float) -> Color {
        if interpolationStyle == .hsb {
            let (leftHue, leftSat, leftBri) = self.getHSB()
            let (rightHue, rightSat, rightBri) = otherColor.getHSB()
            
            let lerpHue = amount.lerp(leftHue, rightHue)
            let lerpSat = amount.lerp(leftSat, rightSat)
            let lerpBri = amount.lerp(leftBri, rightBri)

            return Color(hue: lerpHue, saturation: lerpSat, brightness: lerpBri)
        } else {
            let leftRed = OSColor(self).redComponent
            let rightRed = OSColor(otherColor).redComponent
            
            let leftGreen = OSColor(self).greenComponent
            let rightGreen = OSColor(otherColor).greenComponent
            
            let leftBlue = OSColor(self).blueComponent
            let rightBlue = OSColor(otherColor).blueComponent
                                        
            let lerpRed = amount.lerp(leftRed, rightRed)
            let lerpGreen = amount.lerp(leftGreen, rightGreen)
            let lerpBlue = amount.lerp(leftBlue, rightBlue)
            
            return Color(red: lerpRed, green: lerpGreen, blue: lerpBlue)
        }
    }
}

extension BinaryFloatingPoint {
    func lerp<V: BinaryFloatingPoint>(_ v0: V, _ v1: V) -> V {
        return v0 + V(self) * (v1 - v0);
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
