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
    let dateTextField: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    
    func checkValidAge(date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let datecomponent = calendar.dateComponents([.year, .month, .day], from: Date())
        guard let minimundate = calendar.date(byAdding: .year, value: 17, to: date) else { return false }
        let minimundateComponent = calendar.dateComponents([.year, .month, .day], from: minimundate)
        guard let today = calendar.date(from: datecomponent) else {
            print("🥺 checkValidAge 가드문 갇힘")
            return false }
        guard let birthDay = calendar.date(from: minimundateComponent) else {
            print("🥺 checkValidAge 가드문 갇힘")
            return false }

        return today >= birthDay
    }
}
