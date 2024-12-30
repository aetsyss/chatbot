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
        case pieChart
        case typing
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
            lastMessageId = messages.last?.id ?? UUID()
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
                case "Pie": return Message(side: .their, content: .pieChart)
                default: return Message(side: .their, content: .text("Chat bot response."))
                }
            }()
            
            if let index = messages.firstIndex(of: newMessage) {
                messages.insert(responseMessage, at: index + 1)
            }
        }
    }
}

struct ChatView<ViewModel: ChatViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var message: String = ""
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geomery in
            VStack {
                ScrollView(.vertical) {
                    ScrollViewReader { proxy in
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.messages, id: \.self) { message in
                                MessageView(
                                    side: message.side == .mine ? .mine : .their,
                                    maxWidth: geomery.size.width * 0.85,
                                    status: messageViewStatusFor(message)
                                ) {
                                    componentViewFor(message, size: geomery.size)
                                }
                                .id(message.id)
                            }
                        }
                        .padding(.horizontal)
                        .onChange(of: viewModel.lastMessageId, { _, id in
                            withAnimation {
                                proxy.scrollTo(id, anchor: .bottom)
                            }
                        })
                    }
                }
                
                HStack {
                    TextField("Enter your message", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 8)
                    
                    Button(action: {
                        sendMessage()
                    }) {
                        Text("Ask")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
    }
    
    private func messageViewStatusFor(_ message: Message) -> MessageViewStatus? {
        switch message.status {
        case .error: return .error
        default: return nil
        }
    }
    
    private func componentViewFor(_ message: Message, size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(message.content, id: \.self) { content in
                switch content {
                case .text(let value):
                    switch message.side {
                    case .mine:
                        BubbleTextComponent(text: value, background: .gray.opacity(0.15))
                    case .their:
                        PlainTextComponent(text: value)
                    }
                case let .table(header, content):
                    PlainTableView(header: header, content: content)
                case .linearChart:
                    LinearChartComponent()
                        .frame(height: min(size.width * 0.7, size.height * 0.7))
                        .padding(.vertical)
                case .barChart:
                    BarChartComponent()
                        .frame(height: min(size.width * 0.7, size.height * 0.7))
                case .pieChart:
                    PieChartComponent()
                        .frame(height: min(size.width * 0.7, size.height * 0.7))
                case .typing:
                    TypingSimulationView()
                }
            }
            .cornerRadius(8)
        }
    }
    
    private func sendMessage() {
        let msg = message
        Task {
            await viewModel.sendMessage(msg)
        }
        message = ""
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel())
}
