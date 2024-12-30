//
//  TypingSimulationView.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/27/24.
//

import SwiftUI

struct TypingSimulationView: View {
    @State private var dotCount: Int = 0
    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 4) {
            Text("Thinking")
                .opacity(0.7)
            ForEach(0..<3, id: \.self) { index in
                Text(".")
                    .opacity(dotCount > index ? 1 : 0.2)
                    .font(.headline)
            }
        }
        .onReceive(timer) { _ in
            dotCount = (dotCount + 1) % 4
        }
    }
}

#Preview {
    TypingSimulationView()
}
