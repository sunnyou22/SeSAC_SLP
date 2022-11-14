//
//  ContentView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/14.
//

import UIKit

// 스크롤뷰의 content뷰랑 갈아끼워줄 아이

class ContentView: BaseView {
    
    let ImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let expandableTableView: ExpandableTableView = {
        let view = ExpandableTableView()
        return view
    }()
    
    let FixedTableViw: FixedTableView = {
        let view = FixedTableView()
        return view
    }()
}
