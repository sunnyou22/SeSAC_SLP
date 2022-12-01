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

//디이닛때 노티피케이션 없애주기
final class ChatiViewController: BaseViewController {
    
    private let mainView = ChatView()
    private let viewModel = ChatViewModel()
    private let disposedBag = DisposeBag()
    private let rightbarButtonItem = UIBarButtonItem(image: UIImage(named: Icon.ChatIcon.more.rawValue), style: .plain, target: ChatiViewController.self, action: nil)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name(SocketIOManager.shared.NotificationName), object: nil)
        
        view.backgroundColor = .blue
        
        bindErrorStatus()
        bindGesture()
        bind()
    }
    
    @objc func getMessage(notification: NSNotification) {
        
        let id = notification.userInfo![Payload.CodingKeys.id.rawValue] as! String
        let to = notification.userInfo![Payload.CodingKeys.to.rawValue] as! String
        let from = notification.userInfo![Payload.CodingKeys.from.rawValue] as! String
        let chat = notification.userInfo![Payload.CodingKeys.chat.rawValue] as! String
        let createdAt = notification.userInfo![Payload.CodingKeys.createdAt.rawValue] as! String
        
        var apiValue: [Payload] = []
        let value = Payload(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
//        apiValue.append(value)
        // 소켓에서 오는 데이터를 여기서 넣어줌 -> 램에 저장해줘얗마
//        chatData.accept(apiValue)
    }
 
    override func configure() {
        super.configure()
        
        viewModel.myUid.accept(UserDefaults.getUerIfo?[0].nick ?? "")
    
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
        
        // 수락을 나아중에 해서 상태가 변했을수도 있음
//        채팅목록받아오기 test -> 최신날짜라로 받아와야함
        guard let id = UserDefaults.otherUid else {
            print("\(#file), \(#function) -> 유저 정보를 받아올 수 없습니다 🔴")
            return }
        
        viewModel.fetchChatData(from: id, lastchatDate: "2000-01-01T00:00:00.000Z", idtoken: idToken)
        
        print(viewModel.fetchChatData(from: id, lastchatDate: "2000-01-01T00:00:00.000Z", idtoken: idToken))
        
        print(viewModel.matchingStatus.value)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SocketIOManager.shared.closeConnection()
    }
    
    private func bind() {
        let input = ChatViewModel.Input(tapSendButton: mainView.sendbutton.rx.tap, cancelButton: mainView.moreView.cancelButton.rx.tap, changeMessage: mainView.messageTextView.rx.text)
        let output = viewModel.transform(input: input)
        
        output.tapSendButton
            .drive { [weak self] _ in
                guard let self = self, let uid = UserDefaults.otherUid else {
                    print("\(#file), \(#function) 상대방의 uid가 nil")
                    return }
          
                self.viewModel.sendChat(to: uid, contents: self.viewModel.textViewText.value, idtoken: self.idToken)
            }.disposed(by: disposedBag)
        
        output.changeMessage
            .drive { [weak self] text in
                guard let self = self else { return }
                self.viewModel.textViewText.accept(text)
            }.disposed(by: disposedBag)
        
        output.cancelButton
            .drive { [weak self] _ in
                guard let self = self else { return }
                let alertVC = ChatAlertViewController(statusType: self.viewModel.studyStatus.value)
                self.transition(alertVC, .presentFullScreen)
            }.disposed(by: disposedBag)
        
        viewModel.studyStatus
            .withUnretained(self)
            .bind { vc, status in
                vc.mainView.moreView.cancelButton.setTitle(status.rawValue, for: .normal)
            }.disposed(by: disposedBag)
        
        //데이터 램에 저장해주는거 대신 넣어줘야함
        viewModel.chatData
            .withUnretained(self)
            .bind { vc, data in
                if data.count != 0 {
                    vc.mainView.tableView.reloadData()
                    vc.mainView.tableView.scrollToRow(at: IndexPath(row: data.count - 1, section: 0), at: .bottom, animated: false)
                }
            }.disposed(by: disposedBag)
    }
    
    private func bindErrorStatus() {
        viewModel.commonServer.matchingStatus
            .withUnretained(self)
            .bind { vc, status in
                switch status {
                case .Success:
                    vc.mainView.moreView.cancelButton.setTitle(vc.viewModel.studyStatus.value.rawValue, for: .normal)
                default:
                    print(#file, #function, "오류발생 🔴")
                }
            }.disposed(by: disposedBag)
        
        viewModel.chatApi
            .withUnretained(self)
            .bind { vc, status in
                switch status {
                    
                case .success:
                    vc.mainView.tableView.reloadData()
                    // 여기서 디비 저장하기
                default: break
                }
            }.disposed(by: disposedBag)
    }
    
    private func bindGesture() {
        //키보드 올리기
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
                vc.mainView.moreView.isHidden = !vc.mainView.moreView.isHidden
                vc.viewModel.commonServer.getMatchStatus(idtoken: vc.idToken)
             // 현재 상태 쳌
            }.disposed(by: disposedBag)
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
        return viewModel.chatData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = viewModel.chatData.value[indexPath.row]
        
        if data.from == viewModel.myUid.value {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reuseIdentifier, for: indexPath) as? MyChatTableViewCell else { return UITableViewCell() }
            myCell.messegeLbl.text = data.chat
            myCell.timeLbl.text = data.createdAt
            return myCell
        } else {
            guard let yourCell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
            yourCell.messegeLbl.text = data.chat
            yourCell.timeLbl.text = data.chat
            return yourCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainView.messageTextView.resignFirstResponder()
    }
}
