//
//  SharedStruct.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import Foundation

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
