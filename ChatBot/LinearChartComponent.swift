//
//  LinearChartComponent.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/26/24.
//

import SwiftUI
import Charts

struct LinearChartComponent: View {
    struct DataPoint: Identifiable {
            let id = UUID()
            let value: Double
            let label: String
            let category: String
        }
        
        let combinedData: [DataPoint] = [
            DataPoint(value: 3, label: "Jan", category: "First"),
            DataPoint(value: 8, label: "Feb", category: "First"),
            DataPoint(value: 6, label: "Mar", category: "First"),
            DataPoint(value: 10, label: "Apr", category: "First"),
            DataPoint(value: 5, label: "May", category: "First"),
            DataPoint(value: 7, label: "Jun", category: "First"),
            DataPoint(value: 2, label: "Jul", category: "First"),
            
            
            DataPoint(value: 2, label: "Jan", category: "Second"),
            DataPoint(value: 6, label: "Feb", category: "Second"),
            DataPoint(value: 5, label: "Mar", category: "Second"),
            DataPoint(value: 9, label: "Apr", category: "Second"),
            DataPoint(value: 4, label: "May", category: "Second"),
            DataPoint(value: 6, label: "Jun", category: "Second"),
            DataPoint(value: 3, label: "Jul", category: "Second")
        ]
        
        var body: some View {
            Chart(combinedData) { point in
                LineMark(
                    x: .value("Month", point.label),
                    y: .value("Value", point.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Category", point.category))
            }
            .padding()
        }
}

#Preview {
    LinearChartComponent()
        .frame(height: 300)
}
