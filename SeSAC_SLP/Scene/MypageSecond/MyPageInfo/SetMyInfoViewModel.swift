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
    
    func saveUserInfoToUserDefaults() -> [GetUerIfo] {
        print(UserDefaults.getUerIfo, "✅ 유저 정보 받아오기")
        guard let getUserInfo = UserDefaults.getUerIfo else {
            print("유저 정보를 받아오는 것에 실패했습니다 🔴", #function)
            return []
        }
        // 정보 넣어주기
        return getUserInfo
    }
    
    func postUserInfo(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String, idtoken: String) {
        
        let api = SeSACAPI.setMypage(searchable: searchable, ageMin: ageMin, ageMax: ageMax, gender: gender, study: idtoken)
        
        Network.shared.requestSeSAC(type: SetUserInfo.self, url: api.url, method: .post, headers: api.getheader(idtoken: idtoken)) { response in
            switch response {
            case .success(let success):
                print(success, "포스트 성공 ✅", #function)
            case .failure(let failure):
                print(failure, "포스트 실패 🔴", #function)
            }
        }
    }
}
