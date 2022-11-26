//
//  SearchHeader.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit

//MARK: - 헤더
final class SearchHeaderView: UICollectionReusableView {
    
    enum Section: Int, CaseIterable {
        case quo
        case wish
        
        var title: String {
            switch self {
            case .quo:
                return "지금 주변에는"
            case .wish:
                return "내가 하고싶은"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.verticalEdges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let view = UILabel()
        view.font = .title4_R14
        return view
    }()
}
