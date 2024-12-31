//
//  MessageView.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/28/24.
//

import SwiftUI

enum MessageViewStatus {
    case delivered
    case error
}

struct MessageView<T: View>: View {
    enum Side {
        case mine, their
    }
    
    let side: Side
    let maxWidth: CGFloat
    let status: MessageViewStatus?
    let showFeedback: Bool
    let isLiked: Bool?
    let content: () -> T
    
    init(
        side: Side,
        maxWidth: CGFloat,
        status: MessageViewStatus? = nil,
        showFeedback: Bool = false,
        isLiked: Bool? = nil,
        @ViewBuilder content: @escaping () -> T
    ) {
        self.side = side
        self.maxWidth = maxWidth
        self.status = status
        self.showFeedback = showFeedback
        self.isLiked = isLiked
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                if side == .mine {
                    Spacer()
                }
                
                content()
                    .frame(maxWidth: maxWidth, alignment: side == .mine ? .trailing : .leading)
                    .padding(.bottom, status == nil ? 0 : 10)
                    .overlay(
                        statusButton,
                        alignment: .bottomTrailing
                    )
                
                if side == .their {
                    Spacer()
                }
            }
            
            if showFeedback {
                HStack(spacing: 8) {
                    Text("Like it?")
                        .italic()
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            print("Thumbs up button tapped!")
                        }) {
                            Image(systemName: isLiked == true ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .padding(.horizontal, 12)
                        
                        Button(action: {
                            print("Thumbs up button tapped!")
                        }) {
                            Image(systemName: isLiked == false ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .padding(.horizontal, 12)
                    }
                    
                    Spacer()
                }
                .foregroundStyle(Color.blue)
            }
        }
    }
    
    @ViewBuilder
    private var statusButton: some View {
        if let status {
            Button(action: {
                // Handle button action (e.g., retry for errors)
            }) {
                Image(systemName: statusIconName(for: status))
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(statusBackgroundColor(for: status))
                    .background(.white)
                    .clipShape(Circle())
                    .offset(x: 6, y: 0)
            }
        }
    }
    
    private func statusIconName(for status: MessageViewStatus) -> String {
        switch status {
        case .delivered: "checkmark.circle.fill"
        case .error: "arrow.clockwise.circle.fill"
        }
    }
    
    private func statusBackgroundColor(for status: MessageViewStatus) -> Color {
        switch status {
        case .delivered:
            return .green
        case .error:
            return .red
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MessageView(side: .mine, maxWidth: 300) {
            BubbleTextComponent(
                text: "How many accounts do I have?",
                background: Color.gray.opacity(0.15)
            )
        }
        
        MessageView(side: .their, maxWidth: 300, showFeedback: true) {
            PlainTextComponent(text: "Your total balance across all accounts is $18,142,459.05. The majority of your holdings are in the Brokerage Account ending in 239843")
        }
        
        MessageView(side: .their, maxWidth: 300, showFeedback: true, isLiked: true) {
            PlainTextComponent(text: "Your total balance across all accounts is $18,142,459.05. The majority of your holdings are in the Brokerage Account ending in 239843")
        }
        
        MessageView(side: .mine, maxWidth: 300, status: .delivered) {
            BubbleTextComponent(
                text: "How many accounts do I have?",
                background: Color.gray.opacity(0.15)
            )
        }
        
        MessageView(side: .mine, maxWidth: 300, status: .error) {
            BubbleTextComponent(
                text: "How many accounts do I have?",
                background: Color.gray.opacity(0.15)
            )
        }
        
    }
    .padding()
}
