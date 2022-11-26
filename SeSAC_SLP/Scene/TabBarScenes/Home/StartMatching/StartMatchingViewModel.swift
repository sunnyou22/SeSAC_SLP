//
//  StartMatchingViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import Foundation
import RxCocoa
import RxSwift

final class StartMatchingViewModel {
 
    var type: StartMatcingViewController.Vctype
   
    let data: BehaviorRelay<[FromQueueDB]> = BehaviorRelay<[FromQueueDB]>(value: [])
    
    init(type: StartMatcingViewController.Vctype) {
        self.type = type
    }
    
    //데이터 넣어주기
    func fetchData () {
        switch type {
        case .near:
            guard let fromQueueDB = UserDefaults.searchData?[0].fromQueueDB else { return }
            data.accept(fromQueueDB)
        case .request:
            guard let fromQueueDBRequested = UserDefaults.searchData?[0].fromQueueDBRequested else { return }
            data.accept(fromQueueDBRequested)
        }
    }
}
