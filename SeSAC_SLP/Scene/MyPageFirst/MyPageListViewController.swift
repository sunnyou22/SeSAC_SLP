//
//  MyPageListViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/16.
//

import UIKit
import SnapKit


enum MyPageListIcon: String, CaseIterable {
    case notice
    case faq
    case qna
    case setting_alarm
    case permit
    
    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .faq:
           return "자주 묻는 질문"
        case .qna:
           return "1:1문의"
        case .setting_alarm:
           return "알림 설정"
        case .permit:
            return "이용약관"
        }
    }
}

class MyPageListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MyPageListTableViewCell.self, forCellReuseIdentifier: MyPageListTableViewCell.reuseIdentifier)
      
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MyPageHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageListIcon.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageListTableViewCell.reuseIdentifier, for: indexPath) as? MyPageListTableViewCell else { return UITableViewCell() }
        
        cell.iconImageView.image = UIImage(named: MyPageListIcon.allCases[indexPath.row].rawValue)
        cell.title.text = MyPageListIcon.allCases[indexPath.row].title
        
        return cell
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
