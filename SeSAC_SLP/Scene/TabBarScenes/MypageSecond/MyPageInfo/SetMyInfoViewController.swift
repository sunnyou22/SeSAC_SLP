//
//  SetMyInfoViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/15.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SetMyInfoViewController: BaseViewController {
    
    //좀더 의미적으로 생각해보기
    enum BinaryCase: Int {
        case zero = 0
        case one = 1
    }
    
    lazy var mainView = MyPageInfoScrollView()
    lazy var username = mainView.cardView.nicknameView.nameLabel
    lazy var titleView = mainView.cardView.expandableView.titleStackView
    lazy var reviewView = mainView.cardView.expandableView.reviewLabel
    
    let viewModel = SetMyInfoViewModel()
    let apiViewModel = CommonServerManager()
    let disposeBag = DisposeBag()
    var cardToggle: Bool = false
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.cardView.nicknameView.toggleButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        guard let idtoken = UserDefaults.idtoken else {
            print("다음 버튼을 눌렀는데 토큰이 없어 🔴")
            return }
        print(UserDefaults.idtoken)
        // 통신하기
        apiViewModel.USerInfoNetwork(idtoken: idtoken) { [weak self] data in
            self?.viewModel.fetchingUserInfo.accept(data)
        }
        // 유저디폴츠에 저장된 값 변수에 넣기 -> 인풋아웃풋 구조랑 비슷한거 아닌가 흠
        
        //화면 띄우자마자 저장된 유저정보 보여주기
        // 변경사항이 없을 때 도 저장을 해줘야할까.
        
        //bind
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setnavigation()
    }
    
    // 이후 새싹샵의 인덱스 값에 맞춰서 변경하기
    private func setByThumbnail(backgroundImg: SeSac_Background, sesac: Sesac_Face) {
        mainView.cardView.header.imageView.image = UIImage(named: backgroundImg.rawValue)
        mainView.cardView.header.sesacImage.image = UIImage(named: sesac.rawValue)
    }
    
    func bindData() {
        guard let idtoken = UserDefaults.idtoken else {
            //탈퇴했을때 없을 것 같음 -> 온보딩화면으로 날려주기
            print("토큰없음")
            return
        }
        
        //초기설정 - 데이터 뿌리기
        viewModel.fetchingUserInfo
            .withUnretained(self)
            .bind { vc, data in
                vc.username.text = data.nick
                vc.reviewView.text = data.comment.last ?? "첫 리뷰를 기다리는 중이에요!"
                vc.mainView.fixView.genderView.manButton.backgroundColor = data.gender == Gender.man.rawValue ? .setBrandColor(color: .green) : .setBaseColor(color: .white)
                vc.mainView.fixView.genderView.womanButton.backgroundColor = data.gender == Gender.woman.rawValue ? .setBrandColor(color: .green) : .setBaseColor(color: .white)
                vc.mainView.fixView.setFrequentStudyView.textField.text = data.study
                vc.mainView.fixView.switchView.switchButton.isOn = data.searchable == BinaryCase.one.rawValue ? true : false
                vc.mainView.fixView.matchingAgeView.trackBar.lower = Double(data.ageMin)
                vc.mainView.fixView.matchingAgeView.trackBar.lower = Double(data.ageMax)
                
            }.disposed(by: disposeBag)
        
        //MARK: - 데이터 넣기 숑숑
        //젠더설정
        mainView.fixView.genderView.manButton.rx
            .tap
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, print("남자탭")))
            .drive { vc, _ in
                vc.viewModel.genderStatus.accept((Gender.man, true))
                vc.mainView.fixView.genderView.womanButton.backgroundColor = ValidButtonColor.invalid
                vc.mainView.fixView.genderView.manButton.backgroundColor = ValidButtonColor.valid
            }.disposed(by: disposeBag)
        
        mainView.fixView.genderView.womanButton.rx
            .tap
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, print("여자탭")))
            .drive { vc, _ in
                vc.viewModel.genderStatus.accept((Gender.woman, true))
                vc.mainView.fixView.genderView.womanButton.backgroundColor = ValidButtonColor.valid
                vc.mainView.fixView.genderView.manButton.backgroundColor = ValidButtonColor.invalid
            }.disposed(by: disposeBag)
        
        //스위치 상태설정
        mainView.fixView.switchView.switchButton.rx
            .value
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, false))
            .drive { vc, bool in
                bool ? vc.viewModel.toggleStatus.accept(BinaryCase.one.rawValue) : vc.viewModel.toggleStatus.accept(BinaryCase.zero.rawValue)
            }.disposed(by: disposeBag)

      
        //저장버튼 클뤽
//        navigationItem.rightBarButtonItem?.rx
//            .tap
//            .withUnretained(self)
//            .subscribe(onNext: { vc, _ in
//                var tracker = vc.mainView.fixView.matchingAgeView.trackBar
//                let genderInt = vc.viewModel.genderStatus.value.0 == Gender.woman ? 0 : 1
//
//                vc.viewModel.putUserInfo(searchable: vc.viewModel.toggleStatus.value, ageMin: Int(tracker.lower) , ageMax: Int(tracker.upper), gender: genderInt, study: vc.mainView.fixView.setFrequentStudyView.textField.text ?? "", idtoken: idtoken)
//            }).disposed(by: disposeBag)
    }
 
   private func setnavigation() {
        navigationItem.titleView?.tintColor = .setBaseColor(color: .black)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.setBaseColor(color: .black)]
        navigationItem.title = "정보관리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(postToServer))
   }
    
    @objc private func postToServer() {
        guard let idtoken = UserDefaults.idtoken else {
            print("토큰없음")
            return
        }
        var tracker = mainView.fixView.matchingAgeView.trackBar
        let genderInt = viewModel.genderStatus.value.0 == Gender.woman ? 0 : 1
        viewModel.putUserInfo(searchable: viewModel.toggleStatus.value, ageMin: Int(tracker.lower) , ageMax: Int(tracker.upper), gender: genderInt, study: mainView.fixView.setFrequentStudyView.textField.text ?? "", idtoken: idtoken)
    }
    
    @objc private func test() {
        mainView.cardView.expandableView.isHidden =  !mainView.cardView.expandableView.isHidden
    }
    
}
