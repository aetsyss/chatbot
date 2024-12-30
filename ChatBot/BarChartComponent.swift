//
//  BarChartComponent.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/27/24.
//

import SwiftUI
import Charts

struct BarChartComponent: View {
    struct DataPoint: Identifiable {
        let id = UUID()
        let value: Double
        let label: String
        let color: Color
    }
    
    let dataPoints: [DataPoint] = [
        DataPoint(value: 3, label: "Jan", color: .blue),
        DataPoint(value: 8, label: "Feb", color: .green),
        DataPoint(value: 6, label: "Mar", color: .orange),
        DataPoint(value: 10, label: "Apr", color: .red),
        DataPoint(value: 5, label: "May", color: .purple),
        DataPoint(value: 7, label: "Jun", color: .pink),
        DataPoint(value: 2, label: "Jul", color: .teal)
    ]
    
    var body: some View {
        Chart(dataPoints) { point in
            BarMark(
                x: .value("Value", point.value),
                y: .value("Month", point.label)
            )
            .foregroundStyle(point.color)
        }
    }
}

#Preview {
    BarChartComponent()
        .frame(height: 300)
}
