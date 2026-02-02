//
//  NetworkManager.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/27/26.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    enum NetworkError: Error {
        case badRequest
        case unAuthorized
        case forbidden
        case notFound
        case serverError
        case noResponse
        case decodingError
        case unknown(statusCode: Int?)
        
        var description: String {
            switch self {
            case .badRequest:
                return "잘못된 요청입니다."
            case .unAuthorized:
                return "인증에 실패했습니다."
            case .forbidden:
                return "접근 권한이 없습니다. (한 시간에 50번까지만 호출할 수 있습니다!)"
            case .notFound:
                return "요청한 리소스를 찾을 수 없습니다."
            case .serverError:
                return "서버에서 오류가 발생했습니다."
            case .noResponse:
                return "서버에서의 응답이 없습니다."
            case .decodingError:
                return "디코딩에 실패했습니다."
            case .unknown(statusCode: let statusCode):
                return "알 수 없는 오류가 발생했습니다. (\(statusCode.map(String.init) ?? "no Code"))"
            }
        }
    }
    
    private init() {  }
    
    func callRequest<T: Decodable>(api: NetworkRouter, type: T.Type, success: @escaping (T) -> Void, failure: @escaping (NetworkError) -> Void) {
        AF.request(api.endPoint, method: .get, parameters: api.parameter, headers: api.headers).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
            guard let statusCode = response.response?.statusCode else {
                failure(.noResponse)
                
                return
            }
            
            switch response.result {
            case .success(let value):
                success(value)
                
            case .failure(let error):
                let networkError: NetworkError
                
                switch statusCode {
                case 400:
                    networkError = .badRequest
                case 401:
                    networkError = .unAuthorized
                case 403:
                    networkError = .forbidden
                case 404:
                    networkError = .notFound
                case 500...599:
                    networkError = .serverError
                default:
                    networkError = .unknown(statusCode: statusCode)
                }
                
                failure(networkError)
                
                print(error)
            }
        }
    }
}
