import SwiftUI

struct ChatView<ViewModel: ChatViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var message: String = ""
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
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
                            .padding()
                            .onChange(of: viewModel.lastMessageId) { id in
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .bottom)
                                }
                            }
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
            .navigationTitle("Chatbot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss() // Close the view
                    }) {
                        Image(systemName: "xmark")
                    }
                }
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
//                case .pieChart:
//                    PieChartComponent()
//                        .frame(height: min(size.width * 0.7, size.height * 0.7))
                case .typing:
                    TypingSimulationView()
                case .orderedList:
                    OrderedListComponent(items: [])
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
