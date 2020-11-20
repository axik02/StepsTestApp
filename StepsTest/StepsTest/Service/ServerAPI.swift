//
//  ServerAPI.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation
import Moya

enum ServerAPI {
    case getComments(start: Int, limit: Int)
}

extension ServerAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .getComments:
            return "/comments"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getComments(let start, let limit):
            return ["_start": start,
                    "_limit": limit]
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        case .post:
            return JSONEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments:
            return .get
//        case .:
//            return .post
        }
    }
    
    var sampleData: Data { return Data() }
    
    var task: Task {
        switch self {
        default:
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type" : "application/json"]
    }
    
}
