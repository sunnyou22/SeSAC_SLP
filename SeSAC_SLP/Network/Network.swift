//
//  Network.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/10.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

enum NetworkCommonPrameter<T> {
    case common(type: T.Type = T.self, url: URL, parameter: [String:Any]? = nil, method: HTTPMethod, header: HTTPHeaders)
}


final class Network {
    
    static let shared = Network()
    
    private init() { }
    
    func receiveRequestSeSAC<T: Decodable>(type: T.Type = T.self, url: URL, parameter: [String:Any]? = nil, method: HTTPMethod, headers: HTTPHeaders) -> Single<(T?, Int)> {
        return Single<(T?, Int)>.create { (single) -> Disposable in
            let request = AF.request(url, method: method, parameters: parameter, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: headers)
                .responseDecodable(of: T.self) //responseString 찍어보기
            { response in
                guard let statusCode = response.response?.statusCode else { return }
                
                switch response.result {
                case .success(let data):
                    single(.success((data, statusCode)))
                    print("네트워크 통신 success🔗 상태코드: \(statusCode),\n 데이터 : \(data)")
                    
                case .failure(let error):
                    single(.success((nil, statusCode)))
                    single(.failure(error))
                    print("서버 통신 fail🔗 상태코드: \(statusCode), === \(response.response)")
                }
            }
            return Disposables.create { request.cancel() }
        }.debug("어떻게 나오냐", trimOutput: true)
    }
    
    func sendRequestSeSAC(url: URL, parameter: [String:Any]? = nil, method: HTTPMethod, headers: HTTPHeaders, completion: @escaping ((Int) -> Void)) {
        
        AF.request(url, method: method, parameters: parameter, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: headers)
            .responseString { response in
                guard let statusCode = response.response?.statusCode else {
                    print("상태코드를 알 수 없습니다 🔴", #function)
                    return
                }
                completion(statusCode)
                print("서버통신 서버로 데이터보낸후 응답☑️☑️", response)
            }//responseString 찍어보기
    }
    
    func testSendReuestSeSAC<T: Decodable>(type: T.Type = T.self, url: URL, parameter: [String:Any]? = nil, method: HTTPMethod, headers: HTTPHeaders, completion: @escaping ((T?, Int) -> Void)) {
        
        AF.request(url, method: method, parameters: parameter, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: headers)
            .responseDecodable(of: T.self) //responseString 찍어보기
        { response in
            print(response, "===================")
            switch response.result {
            case .success(let data):
                
                guard let statusCode = response.response?.statusCode else {
                    print("상태코드가 없습니다 🔴 ")
                    return }
                print("포스트 보내기 성공","statusCode: \(statusCode), data: \(data)", #function, #file)
                completion(data, statusCode)
            case .failure(let error):
                guard let statusCode = response.response?.statusCode else { return }
                print("🔴 SignUpError", response.response?.statusCode, error)
                completion(nil, statusCode)
                print(statusCode, "==============")
            }
        }
    }
}
