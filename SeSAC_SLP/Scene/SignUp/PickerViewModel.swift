//
//  PickerViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/11.
//

import Foundation
import RxCocoa
import RxSwift

final class PickerViewModel {
    var buttonValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let yearTextField: BehaviorRelay<String> = BehaviorRelay(value: "")
    let monthTextField: BehaviorRelay<String> = BehaviorRelay(value: "")
    let dateTextField: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func checkValidAge(date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        guard let minimundate = calendar.date(byAdding: .year, value: 17, to: date) else { return false }
        return Date() > minimundate
    }
}
