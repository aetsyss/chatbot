//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/31/24.
//

import SwiftUI

struct Message: Hashable {
    enum Side: Hashable {
        case mine, their
    }
    
    enum Content: Hashable {
        case text(String)
        case table(header: [String], content: [[String]])
        case linearChart
        case barChart
//        case pieChart
        case typing
        case orderedList
    }
    
    enum Status: Hashable {
        case sending
        case delivered
        case error(String)
    }
    
    let id = UUID()
    let side: Side
    let content: [Content]
    var status: Status?
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Message {
    init(side: Message.Side, content: Content, status: Status? = nil) {
        self.init(side: side, content: [content], status: status)
    }
}

protocol ChatViewModelProtocol: ObservableObject {
    var messages: [Message] { get }
    
    var lastMessageId: UUID { get }
    
    func sendMessage(_ message: String) async
}

class ChatViewModel: ObservableObject, ChatViewModelProtocol {
    
    @Published var messages: [Message] = [
        .init(
            side: .their,
            content: .text("Hello there! How can I help?")
        ),
        .init(
            side: .mine,
            content: .text("Show me my transactions from last month. Could you please show me my transactions from last month.")
        ),
        .init(
            side: .their,
            content: [
                .text("Table header"),
                .table(
                    header: ["Name", "Year born", "Place"],
                    content: [["Alex", "Liuda", "Sveta"], ["1984", "1988", "1982"], ["Leninsk, Kazakhskaya SSR", "Shapta", "Finland, Vantaa"]]
                ),
                .text("Table footer")
            ]
        )
    ] {
        didSet {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000)
                lastMessageId = messages.last?.id ?? UUID()
            }
        }
    }
    
    @Published var lastMessageId: UUID = UUID()

    @MainActor
    func sendMessage(_ message: String) async {
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = Message(side: .mine, content: .text(message), status: .sending)
        messages.append(newMessage)
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        let typingMessage = Message(side: .their, content: .typing)
        
        if let index = messages.firstIndex(of: newMessage) {
            messages.insert(typingMessage, at: index + 1)
        }
        
        try? await Task.sleep(nanoseconds: 3_000_000_000)

        if let index = messages.firstIndex(of: typingMessage) {
            messages.remove(at: index)
        }
        
        let isError = message.lowercased().contains("error")
        
        if let index = messages.firstIndex(where: { $0.id == newMessage.id }) {
            messages[index].status = isError ? .error("Server is unavailable") : .delivered
        }
        
        if !isError {
            try? await Task.sleep(nanoseconds: 200_000_000)
            
            let responseMessage: Message = {
                switch message {
                case "Linear": return Message(side: .their, content: .linearChart)
                case "Table": return Message(
                    side: .their,
                    content: .table(
                        header: ["Name", "Year born", "Place"],
                        content: [["Alex", "Liuda", "Sveta"], ["1984", "1988", "1982"], ["Leninsk, Kazakhskaya SSR", "Shapta", "Finland, Vantaa"]]
                    )
                )
                case "Bars": return Message(side: .their, content: [
                    .barChart,
                    .text("Bars chart footer")
                ])
//                case "Pie": return Message(side: .their, content: .pieChart)
                case "List": return Message(side: .their, content: .orderedList)
                default: return Message(side: .their, content: .text("Chat bot response."))
                }
            }()
            
            if let index = messages.firstIndex(of: newMessage) {
                messages.insert(responseMessage, at: index + 1)
            }
        }
    }
}
