//
//  BubbleTextComponent.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/26/24.
//

import SwiftUI

struct BubbleTextComponent: View {
    let text: String
    let background: Color
    
    var body: some View {
        Text(text)
            .padding()
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    VStack {
        HStack {
            Spacer()
            BubbleTextComponent(
                text: "Show me my transactions from last month. Could you please show me my transactions from last month.",
                background: Color.gray.opacity(0.15)
            )
            .frame(maxWidth: 300, alignment: .trailing)
        }
        
        HStack {
            BubbleTextComponent(
                text: "Hello there! How can I help?",
                background: .clear
            )
            .frame(maxWidth: 300, alignment: .leading)
            Spacer()
        }
    }
    .padding(.horizontal)
}
