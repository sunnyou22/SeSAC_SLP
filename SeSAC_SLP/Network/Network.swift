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
    
    func receiveRequestSeSAC<T: Decodable>(type: T.Type = T.self, url: URL, parameter: [String:Any]? = nil, method: HTTPMethod, headers: HTTPHeaders, completion: @escaping ((T?, Int) -> Void)) {
        
        AF.request(url, method: method, parameters: parameter, encoding: URLEncoding.default, headers: headers)
            .responseDecodable(of: T.self) //responseString 찍어보기
        { response in
            print(response, "===================")
            switch response.result {
            case .success(let data):
                
                guard let statusCode = response.response?.statusCode else {
                    print("상태코드가 없습니다 🔴 ")
                    return }
                print("🚀 성공", #function, #file)
                completion(data, statusCode)
                print("🚀\n\(data)")
                print(statusCode, "==============")
            case .failure(let error):
                guard let statusCode = response.response?.statusCode else { return }
                //                guard let error = error(rawValue: statusCode) else { return }
                // 기본적으로 계속 요청해야하는 코드이기 때문에 모델안에서 처리
                // SignUpError에서 statusCode에 해당하는 case를 뱉음
                print("🔴 SignUpError", response.response?.statusCode, error)
                completion(nil, statusCode)
                print(statusCode, "==============")
                
            }
        }
    }
    
    func sendRequestSeSAC(url: URL, parameter: [String:Any]? = nil, method: HTTPMethod, headers: HTTPHeaders, completion: @escaping ((Int) -> Void)) {
        
        AF.request(url, method: method, parameters: parameter, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: headers)
            .responseString { response in
                guard let statusCode = response.response?.statusCode else {
                    print("상태코드를 알 수 없습니다 🔴", #function)
                    return
                }
                completion(statusCode)
                print("서버로 데이터보낸후 응답☑️☑️", response)
            }//responseString 찍어보기
    }
}
