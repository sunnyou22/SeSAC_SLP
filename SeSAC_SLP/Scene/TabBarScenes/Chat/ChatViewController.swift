//
//  ChatiViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/24.
//

import UIKit

import Toast
import RxSwift
import RxCocoa
import RxKeyboard

//디이닛때 노티피케이션 없애주기
final class ChatViewController: BaseViewController {
    
    final let mainView = ChatView()
    final let viewModel = ChatViewModel()
    final let commonserver = CommonServerManager()
    
    final let realmViewModel = RealmViewModel()
    final let disposedBag = DisposeBag()
    private let rightbarButtonItem = UIBarButtonItem(image: UIImage(named: Icon.ChatIcon.more.rawValue), style: .plain, target: ChatViewController.self, action: nil)
    
    //MARK: 뷰 생명주기
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Realm is located at:", ChatDataListRepository.shared.localRealm.configuration.fileURL!)
  
        // 지금 Test로 삭제했다가 다시 넣어주는 걸로 해보기
       let tasks = ChatDataListRepository.shared.fetchDate()
      
        // 수락을 나아중에 해서 상태가 변했을수도 있음
//        채팅목록받아오기 test -> 최신날짜라로 받아와야함
        guard let id = UserDefaults.otherUid else {
            print("\(#function) -> 유저 정보를 받아올 수 없습니다 🔴")
            return }
        
        viewModel.fetchChatData(from: id, lastchatDate: tasks.last?.createdAt ?? "2000-01-01T00:00:00.000Z", idtoken: idToken)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name(SocketIOManager.shared.NotificationName), object: nil)
        
        view.backgroundColor = .blue
        
        bindRealm()
        bindErrorStatus()
        bindGesture()
        bind()
    }
 
    override func configure() {
        super.configure()
        //내 uid 가져오기
        commonserver.USerInfoNetwork(idtoken: idToken, completion: { [weak self] data in
            print("chatviewcontroller에 data 가져오기 성공", data)
            //바 설정 -> 네트워크 통신은 비동기이기 때문
            self?.navigationItem.title = "\(self!.commonserver.userData.value[0].nick)"
            self?.navigationItem.rightBarButtonItem = self?.rightbarButtonItem
        })
  
        // 델리게이트 넘겨주기
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.tableHeaderView = ChatHeaderView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SocketIOManager.shared.closeConnection()
    }
    
    private func bindRealm() {
        realmViewModel.tasks
            .bind { _ in
                print("Realm is located at:", ChatDataListRepository.shared.localRealm.configuration.fileURL!)
            }.disposed(by: disposedBag)
    }
    
    private func bind() {
        let input = ChatViewModel.Input(tapSendButton: mainView.sendbutton.rx.tap, cancelButton: mainView.moreView.cancelButton.rx.tap, changeMessage: mainView.messageTextView.rx.text)
        let output = viewModel.transform(input: input)
        
        output.tapSendButton
            .drive { [weak self] _ in
                guard let self = self, let otheruid = UserDefaults.otherUid else {
                    print("\(#file), \(#function) 상대방의 uid가 nil")
                    return }
                let value = Payload(id: self.commonserver.userData.value[0].id, to: otheruid, from: self.commonserver.userData.value[0].uid, chat: self.viewModel.textViewText.value, createdAt: CustomFormatter.shared.setformatterToString(Date()) ?? "")
                
                self.viewModel.setchatList(addchatList: value)
                
                self.viewModel.sendChat(to: otheruid, contents: self.viewModel.textViewText.value, idtoken: self.idToken)
                
                print(otheruid, self.viewModel.textViewText.value, self.idToken)
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
        
        //데이터 램에 저장해주는거 대신 넣어줘야함, indexpath 방식 말고 생각해보기
        viewModel.serverChatData
            .withUnretained(self)
            .bind { vc, data in
                if data.count != 0 {
                    vc.mainView.tableView.reloadData()
//                    vc.mainView.tableView.scrollToRow(at: IndexPath(row: data.count - 1, section: 0), at: .bottom, animated: false)
                }
            }.disposed(by: disposedBag)
    }
    
    //MARK: - BindErrorStatus
    private func bindErrorStatus() {
        viewModel.commonServer.matchingStatus
            .withUnretained(self)
            .bind { vc, status in
                switch status {
                case .Success:
                    vc.mainView.moreView.cancelButton.setTitle(vc.viewModel.studyStatus.value.rawValue, for: .normal)
                default:
                    print(#function, "오류발생 🔴")
                }
            }.disposed(by: disposedBag)
        
        viewModel.chatApi
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, .success))
            .drive { vc, status in
                switch status {
                case .success:
                  print("채팅보내기 성공~")
                default:
                    print(status)
                    vc.mainView.makeToast("메세지 전송에 실패했습니다", duration: 2, position: .center) { didTap in
                        vc.mainView.tableView.reloadData()
                        vc.viewModel.removeLastChat()
                       
                        // 마지막줄 리로드 스크롤
                    }
                }
            }.disposed(by: disposedBag)
        
        viewModel.fetchChatApi
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, .success))
            .drive { vc, status in
                switch status {
                case .success:
                    vc.viewModel.addLatestDataToRealm()
                default:
                    vc.mainView.makeToast("채팅을 연결할 수 없습니다 ㅜㅜ \(status)", duration: 2, position: .center)
                }
            }.disposed(by: disposedBag)
    }
    
    //MARK: - BindGesture
    private func bindGesture() {
        //키보드 올리기
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                let height = height > 0 ? -height + (self.mainView.safeAreaInsets.bottom) : 0
                self.mainView.containiview.snp.updateConstraints { make in
                    make.height.greaterThanOrEqualTo(52)
                    make.horizontalEdges.equalToSuperview().inset(16)
                    make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(height)
                    make.centerX.equalToSuperview()
                }
                
                self.mainView.tableView.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(height)
                    make.horizontalEdges.equalToSuperview()
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(self.mainView.containiview.snp.top)
                }
            }).disposed(by: disposedBag)
        
        //키보드 숨기기
        RxKeyboard.instance.isHidden
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool in
                if bool {
                    guard let self = self else { return }
                    self.mainView.containiview.snp.updateConstraints { make in
                        make.height.greaterThanOrEqualTo(52)
                        make.horizontalEdges.equalToSuperview().inset(16)
                        make.bottom.equalTo(self.mainView.safeAreaLayoutGuide).offset(-16)
                        make.centerX.equalToSuperview()
                    }
                    
                    self.mainView.tableView.snp.updateConstraints { make in
                        make.top.horizontalEdges.equalToSuperview()
                        make.centerX.equalToSuperview()
                        make.bottom.equalTo(self.mainView.containiview.snp.top)
                    }
                }
            }).disposed(by: disposedBag)
        
//        mainView.messageTextView
//            .rx
//            .
//            .withUnretained(self)
//            .bind { (vc, _) in
//                vc.mainView.messageTextView.resignFirstResponder()
//            }.disposed(by: disposedBag)
        
        mainView.messageTextView
            .rx
            .text.changed.asDriver().drive { text in
                guard let a = self.mainView.messageTextView.font?.lineHeight else { return }
                if self.mainView.messageTextView.contentSize.height / a >= 3 {
                    
                }
                
                
//                guard let a = self.mainView.messageTextView.font?.lineHeight else { return }
//
//                if self.mainView.messageTextView.contentSize.height / a >= 3 {
//                    self.mainView.messageTextView.snp.remakeConstraints { make in
//                        make.height.equalTo(a * 3)
//                        make.verticalEdges.equalTo(self.mainView.containiview.snp.verticalEdges).inset(12)
//                        make.leading.equalTo(self.mainView.containiview.snp.leading).offset(12)
//                        make.trailing.equalTo(self.mainView.sendbutton.snp.leading).offset(8)
//                    }
//                    self.mainView.messageTextView.isScrollEnabled = true
//                    self.mainView.messageTextView.invalidateIntrinsicContentSize()
//                } else {
//                    self.mainView.messageTextView.isScrollEnabled = false
//
//                    self.mainView.messageTextView.snp.remakeConstraints { make in
//                        make.verticalEdges.equalTo(self.mainView.containiview.snp.verticalEdges).inset(12)
//                        make.leading.equalTo(self.mainView.containiview.snp.leading).offset(12)
//                        make.trailing.equalTo(self.mainView.sendbutton.snp.leading).offset(8)
//                    }
//                }
//
//                make.height.lessThanOrEqualTo(messageTextView.font!.lineHeight)
               
            }.disposed(by: disposedBag)
        
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
