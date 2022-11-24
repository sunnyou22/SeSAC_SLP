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
    
    var userInfo: GetUerIfo?
    
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
        apiViewModel.USerInfoNetwork(idtoken: idtoken)
        // 유저디폴츠에 저장된 값 변수에 넣기 -> 인풋아웃풋 구조랑 비슷한거 아닌가 흠
        userInfo = viewModel.saveUserInfoToUserDefaults()[0]
        //화면 띄우자마자 저장된 유저정보 보여주기
        initialSetting()
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
    
  private func initialSetting() {
      guard let userInfo = userInfo else {
          print(userInfo, "userinfo를 받아올 수 없습니다", #file, #function)
          return
      }
      username.text = userInfo.nick
      reviewView.text = userInfo.reviewedBefore[0]
      
  }
    
    func bindData() {
        guard let idtoken = UserDefaults.idtoken else {
            //탈퇴했을때 없을 것 같음 -> 온보딩화면으로 날려주기
            print("토큰없음")
            return
        }
        
        // 타이틀버튼클릭
        
        //저장버튼 클뤽
        navigationItem.rightBarButtonItem?.rx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.viewModel.putUserInfo(searchable: 1, ageMin: 20, ageMax: 25, gender: 0, study: "알고리즘", idtoken: idtoken)
            }).disposed(by: disposeBag)
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
        viewModel.putUserInfo(searchable: 1, ageMin: 20, ageMax: 25, gender: 1, study: "알고리즘", idtoken: idtoken)
    }
    
    @objc private func test() {
        mainView.cardView.expandableView.isHidden =  !mainView.cardView.expandableView.isHidden
    }
    
}
