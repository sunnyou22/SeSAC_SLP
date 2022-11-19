//
//  SetMyInfoViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import Foundation

class SetMyInfoViewModel {
    
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
