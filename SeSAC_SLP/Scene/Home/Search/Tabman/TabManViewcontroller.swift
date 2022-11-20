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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 플로팅 버튼 상태 바꿔주기 이후 서버통신이 성공했을 때 이벤트를 주도록 변경하기
        MapViewModel.ploatingButtonSet.accept(.matching)
        
    }
}
