//
//  ChatiViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/24.
//

import UIKit

class ChatiViewController: BaseViewController, Bindable {
    
    let mainView = ChatView()
    
    let mydumy = ["안녕하세요"]
    let youdumy = ["안녕하세요, 알고리즘 스터딘느 넝제ㅏㅎ;ㅣㅏ뫃;오;ㅣㅁ호;이ㅏㅗ;ㅎ미ㅏㅗ;ㅣ아ㅗㅁ;히ㅗㅇ;미홍;ㅣㅁ호;ㅣㅁㅇ놓;ㅏㅣ"]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = .blue
        
        bind()
    }
    
    override func configure() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
//        mainView.tableView.tableHeaderView = ChatHeaderView()
    }
    
    func bind() {
//        <#code#>
    }
}

extension ChatiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ChatHeaderView()
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reuseIdentifier, for: indexPath) as? MyChatTableViewCell else { return UITableViewCell() }
        guard let yourCell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.reuseIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        
        if indexPath.row >= 0, indexPath.row < 4 {
            return yourCell
        } else {
            return myCell
        }
    }
}
