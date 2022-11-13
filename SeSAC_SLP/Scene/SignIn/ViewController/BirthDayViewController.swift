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
    let viewModel = PickerViewModel()
    var disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        getUserEvent()
        setButtonConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(UserDefaults.date," 🟢", #function)
        setUserDefaultDate()
    }
    
    deinit {
        print(UserDefaults.date, "✅✅✅✅✅")
    }
    
    func setUserDefaultDate() {
        mainView.yearView.datePiceker.date = UserDefaults.date ?? Date()
        mainView.monthView.datePiceker.date = UserDefaults.date ?? Date()
        mainView.dateView.datePiceker.date = UserDefaults.date ?? Date()
    }
    
    func getUserEvent () {
        //이벤트 받아 그리고 date 던저
        mainView.yearView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                vc.setDateFormatter(date: date)
                UserDefaults.date = date
                vc.viewModel.buttonValid.accept(vc.viewModel.checkValidAge(date: date))
            }.disposed(by: disposedBag)
        
        mainView.monthView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                vc.setDateFormatter(date: date)
                UserDefaults.date = date
                vc.viewModel.buttonValid.accept(vc.viewModel.checkValidAge(date: date))
            }.disposed(by: disposedBag)
        
        mainView.dateView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                vc.setDateFormatter(date: date)
                UserDefaults.date = date
                vc.viewModel.buttonValid.accept(vc.viewModel.checkValidAge(date: date))
            }.disposed(by: disposedBag)
        
    }
    
    func setDateFormatter(date: Date) {
        let calendar = Calendar(identifier: .gregorian)
        let datecomponent = calendar.dateComponents([.year, .month, .day], from: date)
        guard let year = datecomponent.year else { return }
        guard let month = datecomponent.month else { return }
        guard let day = datecomponent.day else { return }
        mainView.yearView.dateTextField.text = "\(year)"
        mainView.monthView.dateTextField.text = "\(month)"
        mainView.dateView.dateTextField.text = "\(day)"
        print(year, month, day, "🥺🥺")
        
    }
    
    func setButtonConfigure() {
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
    
    func showDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        mainView.yearView.dateTextField.inputAccessoryView = toolbar
        mainView.monthView.dateTextField.inputAccessoryView = toolbar
        mainView.dateView.dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneDatePicker(){
        self.view.endEditing(true)
    }
}

