//
//  SetMyInfoViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import Foundation

import RxCocoa
import RxSwift
import Alamofire

class SetMyInfoViewModel {
    
    // 수정사항이 생기면 firstreponse 받았을 때 저장버튼 활성화되도록 하기 -> 불필요한 서버요청 막기
    var buttonValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var nextbutton: ControlEvent<Void>?
    let userStatus = PublishRelay<UserStatus>()
    
    func saveUserInfoToUserDefaults() -> [GetUerIfo] {
        print(UserDefaults.getUerIfo, "✅ 유저 정보 받아오기")
        guard let getUserInfo = UserDefaults.getUerIfo else {
            print("유저 정보를 받아오는 것에 실패했습니다 🔴", #function)
            return []
        }
        // 정보 넣어주기
        return getUserInfo
    }
    
    func putUserInfo(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String, idtoken: String) {
        
        let api = SeSACAPI.setMypage(searchable: searchable, ageMin: ageMin, ageMax: ageMax, gender: gender, study: study)
        
        Network.shared.requestSeSAC(type: SetUserInfo.self, url: api.url, parameter: api.parameter, method: .put, headers: api.getheader(idtoken: idtoken)) { [weak self] data, statusCode  in
            
            guard let data = data else {
                print("userData 가져오기 실패 🔴")
                guard let userStatus = UserStatus(rawValue: statusCode) else { return }
                
                switch userStatus {
                case .Success:
                    print("reponse를 정상적으로 받은 뒤 에러 🔴")
                    self?.userStatus.accept(.Success)
                case .SignInUser:
                    self?.userStatus.accept(.SignInUser)
                case .InvaliedNickName:
                    self?.userStatus.accept(.InvaliedNickName)
                case .FirebaseTokenError:
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    self?.userStatus.accept(.FirebaseTokenError)
                case .NotsignUpUser:
                    self?.userStatus.accept(.NotsignUpUser)
                case .ServerError:
                    self?.userStatus.accept(.ServerError)
                case .ClientError:
                    self?.userStatus.accept(.ClientError)
                }
                print("포스트 실패 🔴", #function)
                return
            }
            self?.userStatus.accept(.Success)
            print(data, "포스트 성공 ✅", #function)
        }
    }
}
