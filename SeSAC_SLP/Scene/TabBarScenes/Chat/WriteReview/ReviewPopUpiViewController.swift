//
//  ReviewPopUpiViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/01.
//

import UIKit
import RxCocoa
import RxSwift

class ReviewPopUpiViewController: BaseViewController, Bindable {
  
    var alertView = ReviewPopView()
    let viewModel = ReviewPopViewModel()
    
    override func loadView() {
        view = alertView
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isOpaque = false
        
        // 이렇게 하면 쌍으로 나옴
//        let zip = zip(sesacTitle, viewModel.data.value[0].reputation)
//        print(zip, sesacTitle)
//        zip.forEach { (view, value) in
//            print(view.tag, value)
//            view.backgroundColor = viewModel.reputationValid(value) ? .setBrandColor(color: .green) : .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bind() {
        let input = ReviewPopViewModel.Input(
            goodmanner: alertView.reviewList.first.rx.tap,
            exactTimeAppointment: alertView.reviewList.second.rx.tap,
            fastFeedback: alertView.reviewList.third.rx.tap,
            kindPersonality: alertView.reviewList.four.rx.tap,
            skillfulPersonality: alertView.reviewList.five.rx.tap,
            usefulTime: alertView.reviewList.six.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.goodmanner
            .drive { _ in
                let btn = alertView.reviewList.first
                btn.isSelected = !btn.isSelected
                btn.backgroundColor = btn.isSelected ? .setBrandColor(color: .green) : .setGray(color: .gray4)
            }
        
        output.exactTimeAppointment
            .drive { _ in
                let btn = alertView.reviewList.second
                btn.isSelected = !btn.isSelected
                btn.backgroundColor = btn.isSelected ? .setBrandColor(color: .green) : .setGray(color: .gray4)
            }
        
        output.fastFeedback
            .drive { _ in
                let btn = alertView.reviewList.third
                btn.isSelected = !btn.isSelected
                btn.backgroundColor = btn.isSelected ? .setBrandColor(color: .green) : .setGray(color: .gray4)
            }
        
        output.goodmanner
            .drive { _ in
                let btn = alertView.reviewList.first
                btn.isSelected = !btn.isSelected
                btn.backgroundColor = btn.isSelected ? .setBrandColor(color: .green) : .setGray(color: .gray4)
            }
        output.goodmanner
            .drive { _ in
                let btn = alertView.reviewList.first
                btn.isSelected = !btn.isSelected
                btn.backgroundColor = btn.isSelected ? .setBrandColor(color: .green) : .setGray(color: .gray4)
            }
        
        output.goodmanner
            .drive { _ in
                let btn = alertView.reviewList.first
                btn.isSelected = !btn.isSelected
                btn.backgroundColor = btn.isSelected ? .setBrandColor(color: .green) : .setGray(color: .gray4)
            }
        
    }
}
