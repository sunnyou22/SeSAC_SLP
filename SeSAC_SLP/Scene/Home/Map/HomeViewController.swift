//
//  HomeViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/13.
//

import UIKit
import MapKit // 지도
import CoreLocation

class HomeViewController: BaseViewController {
    
    var mainView = CustomMapView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        mainView.matchingButton.addTarget(self, action: #selector(test), for: .touchUpInside)
    }
    @objc func test() {
        transition(SearchViewController(), .push)
    }
}
