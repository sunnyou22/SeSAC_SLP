//
//  RealmViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/03.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift

class RealmViewModel {
    var task = PublishRelay<Results<PayLoadListTable>>()
}
