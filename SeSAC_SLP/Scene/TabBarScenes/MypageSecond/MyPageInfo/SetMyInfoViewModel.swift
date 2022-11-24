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
    
    enum ButtonTitle: String, CaseIterable {
        case goodManner = "좋은 매너"
        case exactTimeAppointment = "정확한 시간 약속"
        case fastFeedback = "빠른 응답"
        case kindPersonality = "친절한 성격"
        case skillfulPersonality = "능숙한 실력"
        case usefulTime = "유익한 시간"
    }
    
    typealias titleStatus = (button)
    
    // 수정사항이 생기면 firstreponse 받았을 때 저장버튼 활성화되도록 하기 -> 불필요한 서버요청 막기
    var buttonValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var nextbutton: ControlEvent<Void>?
    let userStatus = PublishRelay<UserStatus>()
    let titleStatus = BehaviorRelay(value: false)
    
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
        
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .put, headers: api.getheader(idtoken: idtoken)) { [weak self] statusCode  in
            
                guard let userStatus = UserStatus(rawValue: statusCode) else {
                    print("포스트 실패 🔴", #function)
                    return }
            self?.userStatus.accept(userStatus)
            print("포스트 성공 ✅", #function)
        }
    }
}
