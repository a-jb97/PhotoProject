//
//  Search.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import Foundation

struct Search: Decodable {
    let results: [SearchDetail]
}

struct SearchDetail: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: UrlsDetail
    let likes: Int
    let user: UserDetail
}
