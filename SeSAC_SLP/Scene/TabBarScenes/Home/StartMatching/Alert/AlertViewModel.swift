//
//  AlertViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/28.
//

import Foundation

import RxSwift
import RxCocoa

final class AlertViewModel: EnableDataInNOut {

    struct Input {
        let tapOk: ControlEvent<Void>
        let tapNo: ControlEvent<Void>
    }
    
    struct Output {
        let tapOk: Driver<Void>
        let tapNo: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let tapOk = input.tapOk.asDriver()
        let tapNo = input.tapNo.asDriver()
        return Output(tapOk: tapOk, tapNo: tapNo)
    }

    // 토스트보내기
    let studyrequestMent = PublishRelay<StudyRequestStatus>()
    let studyacceptMent = PublishRelay<StudyAcceptStatus>()
    
    func requestStudy(otheruid: String, idToken: String, alertType: StartMatcingViewController.Vctype) {
        let api: SeSACAPI
        
        switch alertType {
        case .near:
            api = SeSACAPI.studyRequest(otheruid: otheruid)
        case .requested:
            api = SeSACAPI.studyAccept(otheruid: otheruid) 
        }
     
        Network.shared.sendRequestSeSAC(url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idToken)) { [weak self] statusCode in
            switch alertType {
            case .near:
                self?.studyrequestMent.accept(StudyRequestStatus(rawValue: statusCode)!)
                print(api.parameter)
            case .requested:
                self?.studyacceptMent.accept(StudyAcceptStatus(rawValue: statusCode)!) // 바꾸기
            }
           
        }
    }
}
