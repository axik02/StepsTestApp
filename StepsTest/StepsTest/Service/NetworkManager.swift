//
//  NetworkManager.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation
import Moya
import SwiftyJSON

class NetworkManager {
    
    private lazy var provider = MoyaProvider<ServerAPI>()
    
    // MARK: - Feed
    
    func getComments(start: Int,
                     limit: Int,
                     onSuccess: @escaping ([Comment]) -> Void,
                     onError: @escaping (NSError) -> Void,
                     always: (() -> Void)? = nil) {
        provider.request(.getComments(start: start, limit: limit)) { [weak self] (result) in
            guard let self = self else { return }
            self.onResponseResult(result: result,
                                  onSuccess: onSuccess,
                                  onError: onError)
            always?()
        }
    }
    
    // MARK: - On Response
    
    private func onResponseResult<T: Codable>(keyPath: String? = nil,
                                              result: Result<Response, MoyaError>,
                                              onSuccess: @escaping (T) -> Void,
                                              onError: @escaping (NSError) -> Void) {
        switch result {
        case .success(let response):
            print("----------- REQUEST -----------")
            print("\(response.request?.description ?? "")")
            if let body = response.request?.httpBody {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: body, options: .allowFragments)
                    let prettyJSON = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    let stringJSON = String(data: prettyJSON, encoding: .utf8)
                    print("---------- PARAMETERS ----------")
                    print(stringJSON ?? "")
                } catch {
                    print("Couldn't convert request body to JSON")
                }
            }
            print("\(response.response?.description ?? "")")
            print("---------------------------------")
            
            guard
                let responseJSON = try? JSON(data: response.data, options: .allowFragments)
            else {
                print("------ RAW STRING RESPONSE ------")
                let rawString = try? response.mapString()
                print(rawString ?? "")
                print("---------------------------------")
                onError(ErrorHelper.shared.error("Can't map response to JSON", "Can't map response to JSON"))
                return }
            
            print("----------- RESPONSE -----------")
            print(responseJSON)
            print("---------------------------------")
            
            do {
                try self.onSuccessfulResponse(key: keyPath,
                                              response: response,
                                              onSuccess: onSuccess)
            } catch {
                onError(error as NSError)
            }
        case .failure(let error):
            switch error.response?.statusCode ?? 0 {
            case 400...499:
                // Client error
                onError(error as NSError)
            case 500...599:
                // Server error
                onError(error as NSError)
            case 1000...Int.max:
                // Network error
                onError(error as NSError)
            default:
                onError(error as NSError)
            }
        }
    }
    
    private func onSuccessfulResponse<T:Codable>(key: String?,
                                                 response: Moya.Response,
                                                 onSuccess: @escaping (T) -> Void) throws {
        let data = try response.map(T.self, atKeyPath: key, using: JSONDecoder(), failsOnEmptyData: false)
        onSuccess(data)
    }
    
}
