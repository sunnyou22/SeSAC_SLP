//
//  StartMatchingViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import Foundation
import RxCocoa
import RxSwift
// 데이터가 돌아댕기는 과정 ㅇㅋ
// input 어떤 뷰에서 먼 액션을 받아서 보여줄건데 만약에 하나의 뷰에서 다양한 액션이 오간다면? drive 인건가
//굳이 input에 있는 아니만 넣지 않아도 되는 것
// output input에서 받은 이벤트를 transform으로 가공해서 뷰로 던져.

// transform 옵저버블을 ,어떻게 변형해서 최종적으로 어떻게 던질거냐 -> 데이터를 가공하는 역할이기 때문에


final class StartMatchingViewModel: EnableDataInNOut {
    
    var type: StartMatcingViewController.Vctype
    var wishList: [String]?
    let data: BehaviorRelay<[FromQueueDB]> = BehaviorRelay<[FromQueueDB]>(value: [])
    var sesacTitle: Driver<[Int]>?
    let test = PublishRelay<Bool>()
    init(type: StartMatcingViewController.Vctype) {
        self.type = type
    }
    
    struct Input {
//        let reputationValid: ControlProperty<Int>
        let tapChangeStudyBtn: ControlEvent<Void>
        let refreshButton: ControlEvent<Void>
    }
    
    // 바뀐 데이터의 형태여야함
    struct Output {
//        let reputationValid: ControlProperty<Int>
        let tapChangeStudyBtn: Driver<Void>
        let refreshButton: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let tapChangeStudyBtn = input.tapChangeStudyBtn.asDriver()
        let refreshButton = input.refreshButton.asDriver()
    
        return Output(tapChangeStudyBtn: tapChangeStudyBtn, refreshButton: refreshButton)
    }

    func reputationValid(_ value: Int) -> Bool {
        return value != 0 ? true : false
    }
    
    //데이터 넣어주기
    func fetchData () {
        switch type {
        case .near:
            guard let fromQueueDB = UserDefaults.searchData?[0].fromQueueDB else { return }
            let quoData = fromQueueDB.filter { quo in
                guard let wishList = wishList else { return false }
                return quo.studylist.contains { str in
                    wishList.contains(str)
                } // 16부터 가능한 메서드임
            }
            data.accept(quoData)
            
        case .request:
            guard let fromQueueDBRequested = UserDefaults.searchData?[0].fromQueueDBRequested else { return }
            data.accept(fromQueueDBRequested)
        }
    }
}
