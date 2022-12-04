//
//  SetMyInfoViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

/*
 유저디폴츠에 저장해놓은 userinfo없애기
 - 개인정보보안이슈
 */

import Foundation

import RxCocoa
import RxSwift
import Alamofire

final class SetMyInfoViewModel {
    
    // 데이터고 - 나중에 모델로 빼기
    enum ButtonTitle: String, CaseIterable {
        case goodManner = "좋은 매너"
        case exactTimeAppointment = "정확한 시간 약속"
        case fastFeedback = "빠른 응답"
        case kindPersonality = "친절한 성격"
        case skillfulPersonality = "능숙한 실력"
        case usefulTime = "유익한 시간"
    }
    // 다른방법생각하기 여기서 별로 좋진않은듯
    typealias genderStatus = (Gender, Bool)
    
    // 수정사항이 생기면 firstreponse 받았을 때 저장버튼 활성화되도록 하기 -> 불필요한 서버요청 막기
    var buttonValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var userInfo: GetUerIfo?
    let userStatus = PublishRelay<UserStatus>()
    var genderStatus: BehaviorRelay<genderStatus> = BehaviorRelay(value: (Gender.woman, true))
    let fetchingUserInfo = PublishRelay<GetUerIfo>()
    let toggleStatus: BehaviorRelay<Int> = BehaviorRelay(value: 0)

    //나이계산
    func calcurateAge() {
        
    }
    
    func putUserInfo(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String, idtoken: String) {
        
        let api = SeSACAPI.setMypage(searchable: searchable, ageMin: ageMin, ageMax: ageMax, gender: gender, study: study)
        
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .put, headers: api.getheader(idtoken: idtoken)) { [weak self] statusCode in
            
                guard let userStatus = UserStatus(rawValue: statusCode) else {
                    print("포스트 실패 🔴", #function)
                    return }
            self?.userStatus.accept(userStatus)
            print("포스트 성공 ✅", #function)
        }
    }
}
