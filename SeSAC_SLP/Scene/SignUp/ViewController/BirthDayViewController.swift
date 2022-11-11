//
//  BirthDayViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift
import FirebaseCore
import FirebaseAuth

class BirthDayViewController: BaseViewController {

    var mainView = PickerView()
//    let datePicker = UIDatePicker()
    let viewModel = PickerViewModel()
    let disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        setDate()
        bindData()
    }
    
    func setDate() {
        
        showDatePicker()
        mainView.yearView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                vc.changeDate(date: date)
            }.disposed(by: disposedBag)
        
        mainView.monthView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                vc.changeDate(date: date)
            }.disposed(by: disposedBag)
        
        mainView.dateView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                vc.changeDate(date: date)
            }.disposed(by: disposedBag)
    }
    
        func changeDate(date: Date) {
            let calendar = Calendar(identifier: .gregorian)
            let datecomponent = calendar.dateComponents([.year, .month, .day], from: (date))
            guard let year = datecomponent.year else { return }
            guard let month = datecomponent.month else { return }
            guard let day = datecomponent.day else { return }
            
            mainView.yearView.dateTextField.text = "\(year)"
            mainView.monthView.dateTextField.text = "\(month)"
            mainView.dateView.dateTextField.text = "\(day)"
            print(year, month, date, "🥺🥺")
            
            UserDefaults.date = CustomFormatter.setformatter(date: date)
            print(UserDefaults.date, "📍")
            viewModel.buttonValid.accept(viewModel.checkValidAge(date: date))
            print("🔴🔴", viewModel.checkValidAge(date: date))
        }
    
    
    func showDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([spaceButton, cancelButton], animated: false)
        
        mainView.yearView.dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func bindData() {
        viewModel.buttonValid
            .withUnretained(self)
            .bind { vc, bool in
                vc.mainView.nextButton.backgroundColor = bool ? .setBrandColor(color: .green) : .setGray(color: .gray6)
                vc.mainView.yearView.dateTextField.textColor = bool ? .setBaseColor(color: .black) : .setGray(color: .gray7)
                vc.mainView.monthView.dateTextField.textColor = bool ? .setBaseColor(color: .black) : .setGray(color: .gray7)
                vc.mainView.dateView.dateTextField.textColor = bool ? .setBaseColor(color: .black) : .setGray(color: .gray7)
                print("😫", bool)
            }.disposed(by: disposedBag)
        
        mainView.nextButton.rx
            .tap
            .withUnretained(self)
            .bind { vc, _ in
                let viewcontroller = EmailViewController()
                vc.transition(viewcontroller, .push)
            }.disposed(by: disposedBag)
    }
}

