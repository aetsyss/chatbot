//
//  PlainTableView.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/27/24.
//

import SwiftUI

struct PlainTableView: View {
    let header: [String]
    let content: [[String]]
    
    var body: some View {
        VStack(spacing: 1) {
            // Header Row
            HStack {
                ForEach(header, id: \.self) { column in
                    Text(column)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            
            // Content Rows
            ForEach(0..<content[0].count, id: \.self) { rowIndex in
                HStack {
                    ForEach(0..<header.count, id: \.self) { columnIndex in
                        Text(content[columnIndex][rowIndex])
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(rowIndex % 2 == 0 ? Color.white : Color.gray.opacity(0.1))
            }
        }
    }
}

#Preview {
    PlainTableView(
        header: ["Name", "Year born", "Place"],
        content: [["Alex", "Liuda"], ["1984", "1988"], ["Leninsk, Kazakhskaya SSR", "Shapta"]]
    )
}
