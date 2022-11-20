//
//  TabManViewcontroller.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/20.
//

import UIKit

class TabmanViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 플로팅 버튼 상태 바꿔주기 이후 서버통신이 성공했을 때 이벤트를 주도록 변경하기
        MapViewModel.ploatingButtonSet.accept(.matching)
        
        //플로팅 버튼 테스트용
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.showSelectedAlert(title: "플로팅 테스트", message: "플로팅버튼 상태 테스트입니다") { _ in
                MapViewModel.ploatingButtonSet.accept(.matched)
     
            }
        }
    }
}
