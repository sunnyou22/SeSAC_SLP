//
//  ReviewPopViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/01.
//

import Foundation

import RxCocoa
import RxSwift

final class ReviewPopViewModel {
    var reviewButtonList: BehaviorRelay<[Int]> = BehaviorRelay(value: Array(repeating: 0, count: 9))
    let postReviewStatus = PublishRelay<ReviewStatus>()
    let reviewText: BehaviorRelay<String> = BehaviorRelay(value: "")
    var temptList = Array(repeating: 0, count: 9)
    func registerReview(otherUid: String, reputation: [Int], comment: String, idtoken: String) {
        let api = SeSACAPI.review(otheruid: otherUid, reputation: reputation, comment: comment)
        
        print(otherUid, reputation, comment, api.url, api.parameter, api.getheader(idtoken: idtoken), " ======================================")
        
        Network.shared.sendRequestSeSAC(url: api.url, method: .sy, headers: api.getheader(idtoken: idtoken)) { [weak self] statusCode in

            guard let status = ReviewStatus(rawValue: statusCode) else {
                print("statuscode 혹으 data를 받아오는 것에 실패했습니다./n DATA: /n STATUSCODE: \(statusCode) 🔴")
                return
            }
            self?.postReviewStatus.accept(status)
        }
    }
    
//    func checkValid(text: String, list: [Int]) -> Bool {
//        return text.count <= 500 && list.reduce(0, +) > 0
//    alertView.reviewTextView.text.count <= 500 &&
//    }
}
