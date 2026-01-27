//
//  NetworkRouter.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import Foundation
import Alamofire

enum NetworkRouter {
    case topic(topicID: String)
    case search(query: String, page: String, orderBy: String, color: String)
    case statistics(photoID: String)
    
    static var baseURL: String {
        return "https://api.unsplash.com/"
    }
    
    var endPoint: URL {
        switch self {
        case .topic(topicID: let id):
            return URL(string: NetworkRouter.baseURL + "topics/\(id)/photos?page=1")!
        case .search(query: let query, page: let page, orderBy: let orderBy, color: let color):
            return URL(string: NetworkRouter.baseURL + "search/photos?")!
        case .statistics(photoID: let id):
            return URL(string: NetworkRouter.baseURL + "photos/\(id)/statistics?")!
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .topic(topicID: _):
            return ["" : ""]
        case .search(query: let query, page: let page, orderBy: let orderBy, color: let color):
            return ["query" : query, "page" : page, "per_page" : "20", "order_by" : orderBy, "color" : color]
        case .statistics(photoID: _):
            return ["" : ""]
        }
    }
}
