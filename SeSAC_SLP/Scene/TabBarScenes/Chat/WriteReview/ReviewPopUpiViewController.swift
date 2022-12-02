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
    let bag = DisposeBag()
    
    
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
        bind()
    }
    
    func bind() {
        
        let btnList = [
            alertView.reviewList.first,
            alertView.reviewList.second,
            alertView.reviewList.third,
            alertView.reviewList.four,
            alertView.reviewList.five,
            alertView.reviewList.six
        ]
        
        for (index, list) in zip(btnList.indices, btnList) {
            list.rx.tap
                .bind { [weak self] _ in
                    list.isSelected = !list.isSelected
                    list.backgroundColor = list.isSelected ? .setBrandColor(color: .green) : .setBaseColor(color: .white)
                    self!.viewModel.reviewButtonList[index] = list.isSelected ? 1 : 0
                    print(self!.viewModel.reviewButtonList)
                }.disposed(by: bag)
        }
    }
}
