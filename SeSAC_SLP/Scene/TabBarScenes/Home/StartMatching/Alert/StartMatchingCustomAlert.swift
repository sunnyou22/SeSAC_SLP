//
//  StartMatchingCustomAlert.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/28.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class StartMatchingCustomAlert: BaseViewController {
  
    let viewModel = AlertViewModel()
    let commonApiModel = CommonServerManager()
    let bag = DisposeBag()
    
    var type: StartMatcingViewController.Vctype
    let studyrequestMent = PublishRelay<StudyRequestStatus>() // 토스트 보내기
    var data: [FromQueueDB]?
    
    let alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .setBaseColor(color: .white)
        return view
    }()
    
    init(type: StartMatcingViewController.Vctype) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(data as Any, "-> 값전달 🟢")
        
        bind()
        bindErrorHandling()
    }
    
    func bind() {
        guard let data = data?[0] else {
            print(data, "==================값전달받음" )
            print("데이터가 없슴다", #file)
            return }
        let input = AlertViewModel.Input(tapOk: alertView.okButton.rx
            .tap, tapNo: alertView.noButton.rx
            .tap)
        let output = viewModel.transform(input: input)
        
        output.tapOk
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.requestStudy(otheruid: data.uid, idToken: self.idToken, alertType: self.type)
            }.disposed(by: bag)
        
        output.tapNo
            .drive { _ in
                self.dismiss(animated: true)
            }.disposed(by: bag)
    }
    
    func bindErrorHandling() {
        
        guard let data = data?[0] else {
            print("데이터가 없슴다", #file)
            return }
        
        viewModel.studyrequestMent
            .withUnretained(self)
            .bind { vc, status in
                switch status {
                case .Success:
                    vc.showDefaultToast(message: .StudyRequestStatus(.Success))
                case .Requested: // 이미 상대방이 나한테 요청함
                    vc.showDefaultToast(message: .StudyRequestStatus(.Requested)) {
                        vc.viewModel.requestStudy(otheruid: data.uid, idToken: vc.idToken, alertType: .requested)
                    }
                case .FirebaseTokenError:
                    vc.showDefaultToast(message: .StudyRequestStatus(.FirebaseTokenError))
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    print("토큰만료 🔴")
                case .NotsignUpUser:
                    vc.showDefaultToast(message: .StudyRequestStatus(.NotsignUpUser))
                case .ServerError:
                    vc.showDefaultToast(message: .StudyRequestStatus(.ServerError))
                case .ClientError:
                    vc.showDefaultToast(message: .StudyRequestStatus(.ClientError))
                }
            }.disposed(by: bag)
        
        viewModel.studyacceptMent
            .withUnretained(self)
            .bind { vc, status in
                switch status {
                case .success:
                    vc.showDefaultToast(message: .StudyAcceptedStatus(.accepted)) {
                        MapViewModel.ploatingButtonSet.accept(.matched)
                        vc.dismiss(animated: true) {
                            let chatVC = ChatViewController()
                            vc.transition(chatVC, .push)
                            print("채팅화면으로 이동 🟢")
                        }
                    }
                case .othersmatched:
                    vc.showDefaultToast(message: .StudyAcceptedStatus(.othersmatched))
                case .othersStopSearching:
                    vc.showDefaultToast(message: .StudyAcceptedStatus(.othersStopSearching))
                case .accepted:
                    vc.showDefaultToast(message: .StudyAcceptedStatus(.accepted)) {
                        vc.commonApiModel.getMatchStatus(idtoken: vc.idToken)
                    }
                case .firebaseTokenError:
                    print("파이어베이스 토큰 에러 🔴")
                    FirebaseManager.shared.getIDTokenForcingRefresh()
                    vc.viewDidLoad()
                case .notsignUpUser:
                    vc.showDefaultToast(message: .StudyAcceptedStatus(.notsignUpUser))
                case .serverError:
                    vc.showDefaultToast(message: .StudyAcceptedStatus(.serverError))
                case .clientError:
                    vc.showDefaultToast(message: .StudyAcceptedStatus(.clientError))
                }
            }.disposed(by: bag)
    }
    
    override func configure() {
        view.addSubview(alertView)
    }
    
    override func setConstraints() {
        alertView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4.4)
        }
    }
}


    //MARK: - 커스텀 뷰
class CustomAlertView: BaseView {
    let okButton: CutsomButton = {
        let view = CutsomButton(customtype: .defaultOk)
        view.defaultSetting()
        return view
    }()
    
    let noButton: CutsomButton = {
        let view = CutsomButton(customtype: .defaultNo)
        view.defaultSetting()
        return view
    }()
    
    lazy var alertLbl: UILabel = {
        let view = UILabel()
        return setattributeText(view: view, text: "스터디를 요청할게요!\n요청이 수락되면 30분 후에 리뷰를 남길 수 있어요", pointfont: .title1_M16!, subfont: .title4_R14!, location: 0, length: 11, baseColor: .setGray(color: .gray7), pointColor: .setBaseColor(color: .black))
    }()
    
    lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [noButton, okButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    lazy var totalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [alertLbl, buttonStackView])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()
    
    override func configure() {
        self.addSubview(totalStackView)
    }
    
    override func setConstraints() {
        totalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
