//
//  Protocol.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/27.
//

import UIKit

// 이렇게 앞으로 적용해보기
// 프로젝트의 틀을 만들 수 있을 듯
protocol Bindable {
    func bind()
}

// 베이스 뷰 설정
protocol BaseDelegate {

    var idToken: String { get set }
    
    func configure()
    func setConstraints()
    func fetchData()
    func setNavigation()
}

protocol EnableDataInNOut {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

// mvvm 쓸때
typealias BaseSetUIView = Bindable & BaseDelegate

extension BaseDelegate {
    //모든 베이스 뷰에 적용해야하는 기능일 때 uiview를 확장하지 않고 쓰기 좋을 듯
   func setNavigation() {
       
        print("네비게이션 설정되나요~")
    }
}
