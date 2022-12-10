//
//  SearchViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/20.
//

// 뭘 어떻게 만들어서 뷰에 전달할건지

import Foundation

import RxCocoa
import RxSwift
import MapKit
import CoreLocation

final class SearchViewModel {
    
    let queueStatus = PublishRelay<ServerStatus.QueueError>()
    // 그다음 화면에서 검색된 데이터를 기반으로 뷰를 표현 -> 갱신될때 db갈아끼워주기
    var fromQueueDB = UserDefaults.searchData?[0].fromQueueDB ?? []
    var fromRecommend = UserDefaults.searchData?[0].fromRecommend ?? []
    lazy var quoList = fetchQpueue()
    
    var studyList = BehaviorRelay<[String]>(value: [])
    var validWishList = PublishRelay<Bool>()
    var wishList = BehaviorRelay<[String]>(value: [])
    var searchList = BehaviorRelay<[String]>(value: [])
    
    //현재구조에서는 딱히 쓸필요가,,,없을듯
    struct Input {
        let tapSearchButton: ControlEvent<Void>
        let searchbarsearchButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let tapSearchButton: ControlEvent<Void>
        let searchbarsearchButtonClicked: ControlEvent<Void>
    }
    
    // 여기서 데이터를 넣고 처리까지 다할 수있는듯
    func transform(input: Input) -> Output {
        // 데이터의 흐름을 변환해주는 곳
        return Output(tapSearchButton: input.tapSearchButton, searchbarsearchButtonClicked: input.searchbarsearchButtonClicked)
    }

    final func fetchQpueue() -> Array<String> {
        print(fromRecommend, " ---------------------")
        print(studyList.value,"==========")
        return (fromRecommend + Set(studyList.value).sorted().filter { !$0.isEmpty })
    }
    
    //list라는 값을 전달하고 싶음
    func countAroundStudylist() {
        var total = [String]()
        var tempList: Set<String> = []
        fromQueueDB.forEach { list in
            tempList = Set(list.studylist)
            total += tempList.filter { $0 != "anything" }#imageLiteral(resourceName: "스크린샷 2022-12-10 00.45.32.jpg")
        }
        studyList.accept(total.sorted())
    }
    
    // 하고싶은에 해당하는 list를 뷰에 그리고싶어 -> 이게 종착범
    func setWishList(addWishList: [String]) {
        print(wishList.value, "======= addwish 이전")
        var tempList = wishList.value.sorted()
        tempList += addWishList
        print(wishList.value, "======= addwish 이후")
        wishList.accept(Set(tempList).sorted())
    }
    
    func InvalidWishList(add: [String]) {
        guard wishList.value.count < 8 else {
            validWishList.accept(true)
            return
        }
        
        validWishList.accept(false)
        setWishList(addWishList: add)
    }
    
    //새싹찾기 버튼 클ㄹ릭
    func searchSeSACMate(lat: Double, long: Double, studylist: [String], idtoken: String) {
        let api = SeSACAPI.search(lat: lat, lon: long, studylist: studylist)
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { statuscode in
            
            print(statuscode)
        }
    }
}

