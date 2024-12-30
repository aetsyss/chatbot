//
//  PieChartComponent.swift
//  ChatBot
//
//  Created by Aleksei Tsyss on 12/27/24.
//

import SwiftUI
import Charts

struct PieChartComponent: View {
    struct DataPoint: Identifiable {
        let id = UUID()
        let value: Double
        let label: String
        let color: Color
    }
    
    let dataPoints: [DataPoint] = [
        DataPoint(value: 30, label: "Stocks", color: .blue),
        DataPoint(value: 20, label: "Bonds", color: .green),
        DataPoint(value: 25, label: "MFs", color: .orange),
        DataPoint(value: 15, label: "ETFs", color: .red),
        DataPoint(value: 10, label: "Cash", color: .purple)
    ]
    
    var body: some View {
        Chart(dataPoints) { point in
            SectorMark(
                angle: .value("Value", point.value),
                innerRadius: .ratio(0.3),
                outerRadius: .ratio(1.0)
            )
            .foregroundStyle(point.color)
            .annotation(position: .overlay) {
                Text(point.label)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    PieChartComponent()
}
