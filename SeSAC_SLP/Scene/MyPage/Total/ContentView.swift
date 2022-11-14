//
//  ContentView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit
import SnapKit

// 스크롤뷰의 content뷰랑 갈아끼워줄 아이

class ContentView: BaseView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let expandableTableView: ExpandableTableView = {
        let view = ExpandableTableView()
        return view
    }()
    
    let fixedView: FixedView = {
        let view = FixedView()
        return view
    }()

    override func configure() {
        [imageView, expandableTableView, fixedView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            imageView
        }
    }
}
