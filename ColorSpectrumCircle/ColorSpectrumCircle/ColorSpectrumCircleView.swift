//
//  ColorSpectrumCircleView.swift
//  ColorSpectrumCircle
//
//  Created by Alex Shepard on 6/9/22.
//

import SwiftUI

struct ColorSpectrumCircleView: View {
    @State private var saturation = 0.5
    @State private var brightness = 0.5
    
    @State private var segmentCount = 12
    private let segmentOptions = [
        360, 45, 24, 12, 6
    ]
    private let radius: Double = 280
    
    var body: some View {
        VStack {
            Picker("Number of segments", selection: $segmentCount) {
                ForEach(segmentOptions, id: \.self) {
                    Text(String($0))
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Canvas { context, size in
                let radius = (size.width / 2) - 20
                let angleStep = 360 / segmentCount
                let center = CGPoint(x: size.width/2, y: size.height / 2)
                for angle in stride(from: 0, to: 360, by: angleStep) {
                    let vx = (size.width/2) + cos(Angle(degrees: Double(angle)).radians) * radius
                    let vy = (size.height/2) + sin(Angle(degrees: Double(angle)).radians) * radius
                    
                    let vx2 = (size.width/2) + cos(Angle(degrees: Double(angle+angleStep)).radians) * radius
                    let vy2 = (size.height/2) + sin(Angle(degrees: Double(angle+angleStep)).radians) * radius
                    
                    let fillColor = Color(hue: Double(angle)/360.0, saturation: saturation, brightness: brightness)
                    
                    let p = Path { path in
                        path.move(to: center)
                        path.addLine(to: CGPoint(x: vx, y: vy))
                        path.addLine(to: CGPoint(x: vx2, y: vy2))
                    }

                    // fill and stroke otherwise there's a gap
                    context.fill(
                        p,
                        with: .color(fillColor)
                    )
                    context.stroke(
                        p,
                        with: .color(fillColor)
                    )

                }
            }
            .frame(maxWidth: 600, maxHeight: 600)
            .gesture(
                DragGesture()
                    .onChanged {
                        saturation = (1.0 - ($0.location.x/600)).clamped(to: 0...1.0)
                        brightness = (1.0 - ($0.location.y/600)).clamped(to: 0...1.0)
                    }
            )
        }
    }
}

struct ColorSpectrumCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSpectrumCircleView()
    }
}
