//
//  ColorSpectrumGridView.swift
//  ColorSpectrumGrid
//
//  Created by Alex Shepard on 6/9/22.
//

import SwiftUI

struct ColorSpectrumGridView: View {
    @State private var stepX = 800/3
    @State private var stepY = 40
    
    var body: some View {
        Canvas { context, size in
            for y in stride(from: 0, through: 400, by: stepY) {
                for x in stride(from: 0, through: 800, by: stepX) {
                    let rect = CGRect(x: x, y: y, width: x + stepX, height: y + stepY)
                    let color = Color(hue: Double(x)/800.0, saturation: (1 - Double(y)/400.0), brightness: 1.0)
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
        .frame(width: 800, height: 400)
        .gesture(
            DragGesture()
                .onChanged {
                    stepX = Int(800 / $0.location.x)
                        .clamped(to: 2...800)
                    stepY = Int(400 / $0.location.y)
                        .clamped(to: 2...400)
                }
        )
    }
}

struct ColorSpectrumGridView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSpectrumGridView()
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
