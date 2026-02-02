//
//  ChartView.swift
//  PhotoProject
//
//  Created by 전민돌 on 2/1/26.
//

import SwiftUI
import Charts

struct ChartView<T: ChartDataType>: View {
    var viewsData: [T]
    
    var body: some View {
        Chart {
            ForEach(viewsData.indices, id: \.self) { index in
                let data = viewsData[index]
                let date = DateFormat.shared.makeStringToDateChart(data.date)
                
                LineMark(
                    x: .value("Date", date),
                    y: .value("Views", data.value)
                )
                .foregroundStyle(.blue)
            }
        }
        .frame(height: 200)
    }
}
