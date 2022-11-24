//
//  ViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/07.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFontName()
    }
    
    func getFontName() {
        for family in UIFont.familyNames {

            let sName: String = family as String
            print("family: \(sName)")
                    
            for name in UIFont.fontNames(forFamilyName: sName) {
                print("name: \(name as String)")
            }
        }
    }
}

