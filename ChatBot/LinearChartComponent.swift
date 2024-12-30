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
    }
    
    let dataPoints: [DataPoint] = [
        DataPoint(value: 3, label: "Jan"),
        DataPoint(value: 8, label: "Feb"),
        DataPoint(value: 6, label: "Mar"),
        DataPoint(value: 10, label: "Apr"),
        DataPoint(value: 5, label: "May"),
        DataPoint(value: 7, label: "Jun"),
        DataPoint(value: 2, label: "Jul")
    ]
    
    var body: some View {
        Chart(dataPoints) { point in
            LineMark(
                x: .value("Month", point.label),
                y: .value("Value", point.value)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(Color.blue)
        }
    }
}

#Preview {
    LinearChartComponent()
        .frame(height: 300)
}
