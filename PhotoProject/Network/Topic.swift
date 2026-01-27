//
//  Topic.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import Foundation

struct Topic: Decodable {
    let topicList: [TopicDetail]
}

struct TopicDetail: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: [UrlsDetail]
    let likes: Int
    let user: [UserDetail]
}

struct UrlsDetail: Decodable {
    let raw: String
    let small: String
}

struct UserDetail: Decodable {
    let name: String
    let profile_image: [ProfileImageDetail]
}

struct ProfileImageDetail: Decodable {
    let medium: String
}
