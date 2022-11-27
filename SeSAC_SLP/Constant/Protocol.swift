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

protocol BaseDelegate {

    var idToken: String { get set }
    
    func configure()
    func setConstraints()
    func fetchData() 
}

typealias BaseSetUIView = Bindable & BaseDelegate
