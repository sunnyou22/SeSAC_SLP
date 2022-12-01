//
//  ReviewPopViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/01.
//

import Foundation

import RxCocoa
import RxSwift

class ReviewPopViewModel: EnableDataInNOut {
    
    var reviewButtonList = Array(repeating: 0, count: 8)
    
    struct Input {
        let goodmanner: ControlEvent<Void>
        let exactTimeAppointment: ControlEvent<Void>
        let fastFeedback: ControlEvent<Void>
        let kindPersonality: ControlEvent<Void>
        let skillfulPersonality: ControlEvent<Void>
        let usefulTime: ControlEvent<Void>
    }
    
    struct Output {
//        let manner:  Driver<SetMyInfoViewModel.ButtonTitle>
        let goodmanner: Driver<Void>
        let exactTimeAppointment: Driver<Void>
        let fastFeedback: Driver<Void>
        let kindPersonality: Driver<Void>
        let skillfulPersonality: Driver<Void>
        let usefulTime: Driver<Void>
    }
  
    func transform(input: Input) -> Output {
        let goodmanner = input.goodmanner.asDriver()
        let exactTimeAppointment = input.exactTimeAppointment.asDriver()
        let fastFeedback = input.fastFeedback.asDriver()
        let kindPersonality = input.kindPersonality.asDriver()
        let skillfulPersonality = input.skillfulPersonality.asDriver()
        let usefulTime = input.usefulTime.asDriver()
    
        return Output(goodmanner: goodmanner, exactTimeAppointment: exactTimeAppointment, fastFeedback: fastFeedback, kindPersonality: kindPersonality, skillfulPersonality: skillfulPersonality, usefulTime: usefulTime)
    }
}
