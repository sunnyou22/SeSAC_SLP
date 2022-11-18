//
//  MapViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/18.
//

import Foundation
import RxCocoa
import RxSwift

class MapViewModel {
 
    func fetchMapData(lat: Double, long: Double, idtoken: String) {
        let api = SeSACAPI.search(lat: lat, long: long)
        Network.shared.requestSeSAC(type: Search.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { response in
            switch response {
            case .success(let success):
                dump(success)
//                print(success)
                // 응답값을 받아와야함
             
                UserDefaults.searchData = [success]
                print(UserDefaults.searchData, " 🔴 🔴 🔴")
                
                print("맵 좌표값에 대한 응답값 받기 성공 ✅")
            case .failure(let error):
                print("맵 좌표값 받기 에러 🔴", #file, #function)
                print(error)
                
            }
        }
    }
}
