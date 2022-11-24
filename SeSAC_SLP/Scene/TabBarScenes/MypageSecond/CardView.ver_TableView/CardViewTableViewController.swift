//
//  CardViewTableViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import UIKit
import SnapKit

class CardViewTableViewController: BaseViewController {
    
    var mainview = CardViewCellVer()
    var cell = CardViewTableViewCell()
    
    override func loadView() {
        view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainview.tableView.delegate = self
        mainview.tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension CardViewTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        cell = setCell(tableView: tableView, indexPath: indexPath)
        // 여기에 넣어주면 리로드가 2번씩 됡ㅇ;미
        cell.nicknameView.toggleButton.addTarget(self, action: #selector(clickToggleButton), for: .touchUpInside)
        tableView.snp.makeConstraints { make in
            make.height.equalTo(tableView.contentSize.height)
        }
        return cell
    }
    
    @objc func clickToggleButton() {
        cell.expandableView.isHidden = !cell.expandableView.isHidden
        mainview.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func setCell(tableView: UITableView, indexPath: IndexPath) -> CardViewTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardViewTableViewCell.reuseIdentifier, for: indexPath) as? CardViewTableViewCell else { return CardViewTableViewCell()}
        
        return cell
    }
}
