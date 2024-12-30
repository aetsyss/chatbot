//
//  ChatBotApp.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/26/24.
//

import SwiftUI

@main
struct ChatBotApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView(viewModel: ChatViewModel())
        }
    }
}
