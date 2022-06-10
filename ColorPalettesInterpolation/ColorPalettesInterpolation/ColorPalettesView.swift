//
//  ColorPalettesView.swift
//  ColorPalettesInterpolation
//
//  Created by Alex Shepard on 6/10/22.
//

import SwiftUI

enum InterpolationStyle: String, CaseIterable {
    case rgb = "RGB"
    case hsb = "HSB"
}

struct ColorPalettesView: View {
    @State private var cols = 33
    @State private var rows = 6
    @State private var interpolationStyle: InterpolationStyle = .rgb

    @State private var colorsLeft = [Color]()
    @State private var colorsRight = [Color]()
    
    let xRange = 2...100
    let yRange = 2...10
        
    var body: some View {
        VStack {
            HStack(spacing: 50) {
                Picker("Interpolation Style", selection: $interpolationStyle) {
                    ForEach(InterpolationStyle.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                Button("Shuffle Colors", action: shakeColors)
            }
            .padding()
            
            Canvas { context, size in
                
                let rowHeight = size.height / CGFloat(rows)
                let colWidth = size.width / CGFloat(cols)

                
                if colorsLeft.count != 10 { return }
                for y in stride(from: 0, to: size.height, by: rowHeight) {
                    let yIndex = Int(y/size.height*10)
                    let leftColor = colorsLeft[yIndex]
                    let rightColor = colorsRight[yIndex]
                    
                    for x in stride(from: 0, through: size.width, by: colWidth) {
                        let amount = Float(x/(size.width-colWidth))
                        let lerpColor = leftColor.lerp(
                            otherColor: rightColor,
                            interpolationStyle: interpolationStyle,
                            amount: amount
                        )

                        let rect = CGRect(x: x, y: y, width: size.width/CGFloat(cols), height: size.height/CGFloat(rows))
                        context.fill(Path(rect), with: .color(lerpColor))
                        context.stroke(Path(rect), with: .color(lerpColor), style: .init(lineWidth: 1))
                    }
                }
            }
            .frame(width: 800, height: 800)
            .padding()
            .task {
                DispatchQueue.main.async {
                    self.shakeColors()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged {
                        cols = (Int($0.location.x)/8)
                            .clamped(to: xRange)
                        rows = (Int($0.location.y)/80)
                            .clamped(to: yRange)
                    }
            )
        }
    }
    
    func shakeColors() {
        colorsLeft.removeAll(keepingCapacity: true)
        colorsRight.removeAll(keepingCapacity: true)
        
        for _ in 0..<10 {
            colorsLeft.append(Color.init(
                hue: CGFloat.random(in: 0...0.25),
                saturation: CGFloat.random(in: 0...0.6),
                brightness: 1.0
            ))
            colorsRight.append(Color.init(
                hue: CGFloat.random(in: 0.63...0.75),
                saturation: 0.4,
                brightness: CGFloat.random(in: 0.6...1.0)
            ))
        }
    }
}

struct ColorPalettesView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPalettesView()
    }
}
