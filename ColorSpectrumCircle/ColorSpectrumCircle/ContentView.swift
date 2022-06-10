//
//  ContentView.swift
//  ColorSpectrumCircle
//
//  Created by Alex Shepard on 6/9/22.
//

import SwiftUI

struct ContentView: View {
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
                let angleStep = 360 / segmentCount
                let center = CGPoint(x: size.width/2, y: size.height / 2)
                for angle in stride(from: 0, through: 360, by: angleStep) {
                    let vx = (600/2) + cos(Angle(degrees: Double(angle)).radians) * radius
                    let vy = (600/2) + sin(Angle(degrees: Double(angle)).radians) * radius
                    
                    let vx2 = (600/2) + cos(Angle(degrees: Double(angle+angleStep)).radians) * radius
                    let vy2 = (600/2) + sin(Angle(degrees: Double(angle+angleStep)).radians) * radius
                    
                    let fillColor = Color(hue: Double(angle)/360.0, saturation: saturation, brightness: brightness)
                    
                    context.fill(
                        Path { path in
                            path.move(to: center)
                            path.addLine(to: CGPoint(x: vx, y: vy))
                            path.addLine(to: CGPoint(x: vx2, y: vy2))
                        },
                        with: .color(fillColor)
                    )
                }
            }
            .frame(width: 600, height: 600)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

