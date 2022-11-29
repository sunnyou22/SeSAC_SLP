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

final class ChatiViewController: BaseViewController {
    
    private let mainView = ChatView()
    private let viewModel = ChatViewModel()
    private let disposedBag = DisposeBag()
    private let rightbarButtonItem = UIBarButtonItem(image: UIImage(named: Icon.ChatIcon.more.rawValue), style: .plain, target: ChatiViewController.self, action: nil)
    private let moreView = MoreButtonView()
    
    let mydumy = ["안녕하세요"]
    let youdumy = ["안녕하세요, 알고리이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다.이건 테스트입니다즘 스터딘느 넝제ㅏㅎ;ㅣㅏ뫃;오;ㅣㅁ호;이ㅏㅗ;ㅎ미ㅏㅗ;ㅣ아ㅗㅁ;히ㅗㅇ;미홍;ㅣㅁ호;ㅣㅁㅇ놓;ㅏㅣ"]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        //채팅목록받아오기 test -> 최신날짜라로 받아와야함
        print(viewModel.fetchChatData(from: UserDefaults.getUerIfo![0].id, lastchatDate: "2022-11-29T19:10:46.185Z", idtoken: idToken)!)
        
        bindGesture()
        bind()
        // 채팅창에 진입할 때 나의 매칭상태 확인하기
        viewModel.checkMyQueueStatus(idtoken: idToken)
    }
    
    override func configure() {
        super.configure()
        guard let name = UserDefaults.getUerIfo?[0].nick else {
            print("\(#file), \(#function) -> 유저 정보를 받아올 수 없습니다 🔴")
            return }
        
        // 델리게이트 넘겨주기
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.tableHeaderView = ChatHeaderView()
        
        //바 설정
        navigationItem.title = "\(name)"
        navigationItem.rightBarButtonItem = rightbarButtonItem
    }
    
    fileprivate func bind() {
        let input = ChatViewModel.Input(tapSendButton: mainView.sendbutton.rx.tap, changeMessage: mainView.messageTextView.rx.text)
        let output = viewModel.transform(input: input)
        
        output.tapSendButton
            .drive { [weak self] _ in
                guard let self = self, let uid = self.viewModel.matchingStatus.value[0].matchedUid else {
                    print("\(#file), \(#function) 상대방의 uid가 nil")
                    return }
                
                self.viewModel.sendChat(to: uid, contents: self.viewModel.textViewText.value, idtoken: self.idToken)
            }.disposed(by: disposedBag)
        
        output.changeMessage
            .drive { [weak self] text in
                guard let self = self else { return }
                self.viewModel.textViewText.accept(text)
            }.disposed(by: disposedBag)
    }
    
    fileprivate func bindErrorStatus() {
        // 채팅화면에 진입했는데 스터디 취소가 된 상태라면?
    }
    
    fileprivate func bindGesture() {
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
        
        //오른쪽 바 버튼 아이템 클뤽
        rightbarButtonItem.rx
            .tap
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, print("더보기 버튼 클릭")))
            .drive { (vc, _) in
                
            }
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
