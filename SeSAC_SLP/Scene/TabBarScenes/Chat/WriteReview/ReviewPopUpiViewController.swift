//
//  ReviewPopUpiViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/01.
//

import UIKit
import RxCocoa
import RxSwift
import RxKeyboard
import RxGesture

final class ReviewPopUpiViewController: BaseViewController, Bindable {
    
    private var alertView = ReviewPopView()
    private let commonserver = CommonServerManager()
    private let viewModel = ReviewPopViewModel()
    private let bag = DisposeBag()
    
    
    override func loadView() {
        view = alertView
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isOpaque = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonserver.getMatchStatus(idtoken: idToken)
        
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
                .withUnretained(self)
                .asDriver(onErrorJustReturn: (self, print("tap구독완료, \(index)")))
                .drive { vc, _ in
                    list.isSelected = !list.isSelected
                    list.backgroundColor = list.isSelected ? .setBrandColor(color: .green) : .setBaseColor(color: .white)
                    vc.viewModel.temptList[index] = list.isSelected ? 1 : 0
                    vc.viewModel.reviewButtonList.accept(vc.viewModel.temptList)
                    print(vc.viewModel.reviewButtonList.value, "-----------------------", vc.viewModel.temptList)
                }.disposed(by: bag)
        }
        
        alertView.registerButton.rx
            .tap
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, print("리뷰버튼 구독")))
            .drive { vc, _ in
                if vc.viewModel.reviewButtonList.value.reduce(0, +) > 0 {
                    vc.alertView.registerButton.backgroundColor = .setBrandColor(color: .green)
                    guard let otheruid = UserDefaults.otherUid else { return }
                    vc.viewModel.registerReview(otherUid: otheruid, reputation: vc.viewModel.reviewButtonList.value, comment: vc.alertView.reviewTextView.text, idtoken: vc.idToken)
                } else {
                    vc.alertView.makeToast("최소한 한 개 이상의 키워드를 선택해주세요!", duration: 1, position: .center)
                }
            }.disposed(by: bag)
        
        alertView.reviewTextView.rx
            .text
            .orEmpty
            .map { text in
                text.count }
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, 0))
            .drive { (vc, value) in
                if value > 500 {
                    vc.alertView.reviewTextView.isUserInteractionEnabled = false
                    vc.alertView.makeToast("500자 이상 입력할 수 없습니다.", duration: 1, position: .center) { didTap in
                        vc.alertView.reviewTextView.isUserInteractionEnabled = true
                    }
                }
            }.disposed(by: bag)
        
        alertView.reviewTextView.rx
            .text
            .orEmpty
            .changed
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, "자세한 피드백은 다른 새싹들에게 도움이 됩니다\n(500)"))
            .drive { vc, value in
                vc.alertView.reviewTextView.text = value
            }.disposed(by: bag)
        
        //키보드 올리기
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                let height = height > 0 ? -height + (self.alertView.safeAreaInsets.bottom) : 0
                self.alertView.baseView.snp.remakeConstraints { make in
                    make.verticalEdges.equalTo(self.alertView.stackView).offset(16)
                    make.horizontalEdges.equalToSuperview().inset(16)
                    make.center.equalToSuperview()
                    make.bottom.equalToSuperview().offset(height)
                }
            }).disposed(by: bag)
        
        //키보드 숨기기
        RxKeyboard.instance.isHidden
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                if bool {
                    guard let self = self else { return }
                    self.alertView.baseView.snp.remakeConstraints { make in
                        make.verticalEdges.equalTo(self.alertView.stackView).offset(16)
                        make.horizontalEdges.equalToSuperview().inset(16)
                        make.center.equalToSuperview()
                    }
                }
            }).disposed(by: bag)
        
        alertView.rx.gesture(.swipe(direction: .down))
            .when(.recognized)
            .asDriver{ _ in .never() }
            .drive { [weak self] _ in
                self?.alertView.reviewTextView.resignFirstResponder()
            }.disposed(by: bag)
    }
}
