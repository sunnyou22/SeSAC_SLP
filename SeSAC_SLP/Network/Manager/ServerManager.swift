//
//  ServerManager.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import Foundation

final class ServerManager {
    static let shared = ServerManager()
    private init() { }
    
    func logInNetwork(idtoken: String, sendUserStatus: @escaping (() -> Void))  {
        let api = SeSACAPI.getUserInfo
        
        Network.shared.requestSeSAC(type: LogIn.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] response in
            
            LoadingIndicator.showLoading()
            
            switch response {
            case .success(let success):
                print("로그인 성공 ✅", success)
                //                self?.login.onNext(success)
                LoadingIndicator.hideLoading()
              sendUserStatus()
            case .failure(let failure):
                
                switch failure {
                case SignUpError.FirebaseTokenError:
                    LoadingIndicator.hideLoading()
                    print(#function, "idtoken만료 🔴", failure)
                    guard let DBitoken = FirebaseManager.shared.getIDTokenForcingRefresh() else { return }
                    UserDefaults.idtoken = DBitoken
                    self?.autoUserStaus.accept(.FirebaseTokenError)
                    
                case SignUpError.NotsignUpUser:
                    LoadingIndicator.hideLoading()
                    guard let DBitoken = FirebaseManager.shared.getIDTokenForcingRefresh() else { return }
                    UserDefaults.idtoken = DBitoken
                    self?.autoUserStaus.accept(.NotsignUpUser)
                default:
                    LoadingIndicator.hideLoading()
                   print("🔴 기타 에러, \(failure)")
                }
                //                self?.login.onError(failure)
            }
        }
    }
}
