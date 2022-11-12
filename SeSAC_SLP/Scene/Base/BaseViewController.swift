//
//  BaseViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import Foundation

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
    }
    
    func configure() { }
    func setContents() { }
}
