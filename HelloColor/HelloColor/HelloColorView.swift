//
//  HelloColorView.swift
//  HelloColor
//
//  Created by Alex Shepard on 6/9/22.
//

import SwiftUI

struct HelloColorView: View {
    @State private var rectHue: CGFloat = 0.3
    @State private var rectScale: CGFloat = 0.5
    
    private var fgColor: Color {
        .init(hue: rectHue, saturation: 1, brightness: 1)
    }
    
    private var bgColor: Color {
        .init(hue: 1-rectHue, saturation: 1, brightness: 1)
    }
    
    private var inset: CGFloat {
        // inset by up to 360 on each side of center
        return (720/2) * (1-rectScale)
    }
        
    var body: some View {
        Canvas { context, size  in
            context.fill(
                Path(CGRect(x: 0, y: 0, width: 720, height: 720)
                    .insetBy(dx: inset, dy: inset)
                ),
                with: .color(fgColor)
            )
        }
        .frame(width: 720, height: 720)
        .background(bgColor)
        .gesture(
            DragGesture()
                .onChanged {
                    rectHue = ($0.location.x / 720).clamped(to: 0...1.0)                    
                    rectScale = ($0.location.y / 720).clamped(to: 0...1.0)
                }
        )
    }
}

struct HelloColorView_Previews: PreviewProvider {
    static var previews: some View {
        HelloColorView()
    }
}
