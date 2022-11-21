//
//  Network.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/10.
//

import Foundation
import Alamofire

final class Network {
    
    static let shared = Network()
    
    private init() { }
    
    func requestSeSAC<T: Decodable>(type: T.Type = T.self, url: URL, parameter: [String:Any]? = nil, method: HTTPMethod, headers: HTTPHeaders, completion: @escaping ((Result<T, Error>) -> Void), errorHandler: @escaping ((Int) -> Void)) {
        
        AF.request(url, method: method, parameters: parameter, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: T.self)
        { response in
                
            switch response.result {
            case .success(let data):
                print("🚀🚀 성공")
                print("🚀\n\(data)")
                completion(.success(data))
                
            case .failure(let error):
                guard let statusCode = response.response?.statusCode else { return }
//                guard let error = error(rawValue: statusCode) else { return }
                // 기본적으로 계속 요청해야하는 코드이기 때문에 모델안에서 처리
                if statusCode == 401 {
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    
                }
                
                // SignUpError에서 statusCode에 해당하는 case를 뱉음
                print("🔴 SignUpError", response.response?.statusCode, error)
                completion(.failure(error))
                print(statusCode, "==============")
                errorHandler(statusCode)
                
            }
        }
    }
}

