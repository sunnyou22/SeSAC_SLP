//
//  ContentView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit
import SnapKit

// 스크롤뷰의 content뷰랑 갈아끼워줄 아이
//
//class ContentView: BaseView {
//
//    let expandableTableView: ExpandableStackView = {
//        let view = ExpandableStackView()
//        view.clipsToBounds = true
//        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
//        return view
//    }()
//
//    let headerView = Header()
//
//    override func configure() {
//        [expandableTableView, headerView].forEach { self.addSubview($0) }
//    }
//
//    override func setConstraints() {
//
//        headerView.snp.makeConstraints { make in
//            make.top.equalTo(self.safeAreaLayoutGuide)
//            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(16)
//            make.bottom.equalTo(expandableTableView.snp.top)
//        }
//        
//        expandableTableView.snp.makeConstraints { make in
//            make.top.equalTo(headerView.snp.bottom)
//            make.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(16)
////            make.height.equalTo(imageView.snp.height).dividedBy(3.8) // 높이 생각해보기
//        }
//
//        
//    }
//}
