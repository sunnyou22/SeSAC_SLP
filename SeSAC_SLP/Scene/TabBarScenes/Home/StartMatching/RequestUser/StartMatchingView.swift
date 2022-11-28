//
//  StartMatchingView.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit

final class StartMatchingView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(StartMatchingCollectionViewCell.self, forCellReuseIdentifier: StartMatchingCollectionViewCell.reuseIdentifier)
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    let placeholderImg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Placeholder.NearSeSASC.placeholderImg.str)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let placeholderString: UILabel = {
        let view = UILabel()
        view.text = Placeholder.NearSeSASC.ment.str
        return view
    }()

    let changeStudyButton: UIButton = {
        let view = UIButton()
        view.setTitle("스터디 변경하기", for: .normal)
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.backgroundColor = .setBrandColor(color: .green)
        return view
    }()
    
    let refreshButton: UIButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = CustomCornerRadius.button.rawValue
        view.layer.borderColor = UIColor.setBrandColor(color: .green).cgColor
        view.layer.borderWidth = 1
        view.setImage(UIImage(named: Icon.refreshButton.rawValue), for: .normal)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [changeStudyButton, refreshButton])
        view.spacing = 8
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    
    override func configure() {
        [placeholderImg, placeholderString, stackView, tableView].forEach { self.addSubview($0) }
        self.backgroundColor = .setBaseColor(color: .white)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        placeholderImg.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-40)
            make.width.equalTo(self.snp.width).dividedBy(3)
            make.height.equalTo(self.snp.width)
        }
        
        placeholderString.snp.makeConstraints { make in
            make.top.equalTo(placeholderImg.snp.bottom).offset(16)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        
        }
    }
}
