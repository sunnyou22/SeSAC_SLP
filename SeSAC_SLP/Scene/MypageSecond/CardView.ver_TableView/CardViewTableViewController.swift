//
//  CardViewTableViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import Foundation

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
}

extension CardViewTableViewController: UITableViewDelegate, UITableViewDataSource {
 
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardViewTableViewCell.reuseIdentifier, for: indexPath) as? CardViewTableViewCell else { return UITableViewCell()}
//
//        return cell
//

        cell = setCell(tableView: tableView, indexPath: indexPath)

        cell.cardView.nicknameView.toggleButton.addTarget(self, action: #selector(clickToggleButton), for: .touchUpInside)

        return cell
    }
    
    @objc func clickToggleButton() {
        cell.cardView.expandableView.isHidden = !cell.cardView.expandableView.isHidden
        mainview.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func setCell(tableView: UITableView, indexPath: IndexPath) -> CardViewTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardViewTableViewCell.reuseIdentifier, for: indexPath) as? CardViewTableViewCell else { return CardViewTableViewCell()}
        
        return cell
    }
}
