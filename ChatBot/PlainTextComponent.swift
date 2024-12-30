//
//  PlainTextComponent.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/26/24.
//

import SwiftUI

struct PlainTextComponent: View {
    let text: String
    
    var body: some View {
        Text(text)
    }
}

#Preview {
    PlainTextComponent(text: "Hello there! How can I help?")
}
