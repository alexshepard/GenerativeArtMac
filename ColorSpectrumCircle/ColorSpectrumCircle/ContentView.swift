//
//  ContentView.swift
//  ColorSpectrumCircle
//
//  Created by Alex Shepard on 6/9/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ColorSpectrumCircleView()
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

