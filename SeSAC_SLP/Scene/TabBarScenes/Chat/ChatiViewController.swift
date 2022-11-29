//
//  ChatiViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

class ChatiViewController: BaseViewController {
    
    let mainView = ChatView()
    let viewModel = ChatViewModel()
    let disposedBag = DisposeBag()
    
    let mydumy = ["안녕하세요"]
    let youdumy = ["안녕하세요, 알고리이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다즘 스터딘느 넝제ㅏㅎ;ㅣㅏ뫃;오;ㅣㅁ호;이ㅏㅗ;ㅎ미ㅏㅗ;ㅣ아ㅗㅁ;히ㅗㅇ;미홍;ㅣㅁ호;ㅣㅁㅇ놓;ㅏㅣ"]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        bindGesture()
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.tableHeaderView = ChatHeaderView()
    }
    
    func bind() {
        
    }
    
    func bindGesture() {
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                let height = height > 0 ? -height + (self.mainView.safeAreaInsets.bottom) : 0
                self.mainView.containiview.snp.updateConstraints { make in
                    make.height.equalTo(52)
                    make.horizontalEdges.equalToSuperview().inset(16)
                    make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(height)
                    make.centerX.equalToSuperview()
                }
                
                self.mainView.tableView.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(height)
                    make.horizontalEdges.equalToSuperview()
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(self.mainView.containiview.snp.top).offset(-height)
                }
                
                self.mainView.layoutIfNeeded()
            }).disposed(by: disposedBag)
        
        //키보드 숨기기
        RxKeyboard.instance.isHidden
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                if bool {
                    guard let self = self else { return }
                    self.mainView.containiview.snp.updateConstraints { make in
                        make.height.equalTo(52)
                        make.horizontalEdges.equalToSuperview().inset(16)
                        make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(-16)
                        make.centerX.equalToSuperview()
                    }
                    
                    self.mainView.tableView.snp.updateConstraints { make in
                        make.top.horizontalEdges.equalToSuperview()
                        make.centerX.equalToSuperview()
                        make.bottom.equalTo(self.mainView.containiview.snp.top)
                    }
                    self.mainView.layoutIfNeeded()
                }
            }).disposed(by: disposedBag)
     
    }
}


extension ChatiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ChatHeaderView()
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reuseIdentifier, for: indexPath) as? MyChatTableViewCell else { return UITableViewCell() }
        guard let yourCell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
 
        if indexPath.row >= 0, indexPath.row < 4 {
            yourCell.messegeLbl.text = youdumy[0]
            return yourCell
        } else {
            myCell.messegeLbl.text = mydumy[0]
            return myCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainView.messageTextView.resignFirstResponder()
    }
}
