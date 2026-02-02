//
//  Statistics.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import Foundation

struct Statistics: Decodable {
    let id: String
    let downloads: DownloadsDetail
    let views: ViewsDetail
}

struct DownloadsDetail: Decodable {
    let total: Int
    let historical: HistorycalDetail
}

struct ViewsDetail: Decodable {
    let total: Int
    let historical: HistorycalDetail
}

struct HistorycalDetail: Decodable {
    let values: [ValuesDetail]
}

struct ValuesDetail: Decodable, ChartDataType {
    let date: String
    let value: Int
}
