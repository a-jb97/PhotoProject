//
//  Topic.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import Foundation

struct Topic: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: UrlsDetail
    let likes: Int
    let user: UserDetail
}
