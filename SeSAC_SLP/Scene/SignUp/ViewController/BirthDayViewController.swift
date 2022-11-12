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
    var disposedBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        view = mainView
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        print(UserDefaults.date," 🟢")
        setDateformatter(date: UserDefaults.date ?? Date())
        setDate()
        bindData()
        
      print(UserDefaults.idtoken)
        
    }

    deinit {
        print("디이닛이 되남~~")
    }
    
    func setDateformatter(date: Date) {
      
    }
    
    func setDate() {
        //누가 준건지 몰라 근데 date 받음 -> 공통적인 이벤트 처리할 때 좋은 듯
        viewModel.dateTextField
            .withUnretained(self)
            .bind { vc, date in
                vc.mainView.yearView.datePiceker.date = date
                vc.mainView.monthView.datePiceker.date = date
                vc.mainView.dateView.datePiceker.date = date

                //                vc.showDatePicker()
                UserDefaults.date = CustomFormatter.setformatter(date: date)

                let calendar = Calendar(identifier: .gregorian)
                let datecomponent = calendar.dateComponents([.year, .month, .day], from: date)
                guard let year = datecomponent.year else { return }
                guard let month = datecomponent.month else { return }
                guard let day = datecomponent.day else { return }
                
                vc.mainView.yearView.dateTextField.text = "\(year)"
                vc.mainView.monthView.dateTextField.text = "\(month)"
                vc.mainView.dateView.dateTextField.text = "\(day)"
                print(year, month, date, "🥺🥺")
                
                print(UserDefaults.date!, "📍UserDefaults.date")
                vc.viewModel.buttonValid.accept(vc.viewModel.checkValidAge(date: date))
                print("🔴🔴", vc.viewModel.checkValidAge(date: date))
                
            }.disposed(by: disposedBag)
   
        //이벤트 받아 그리고 date 던저
        mainView.yearView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                vc.mainView.yearView.datePiceker.date = UserDefaults.date!
                //                vc.changeDate(date: date)
                print("yearView", date, UserDefaults.date)
                vc.viewModel.dateTextField.accept(date)
//                UserDefaults.date = CustomFormatter.setformatter(date: date)
//                vc.viewModel.dateTextField.accept(date)
            }.disposed(by: disposedBag)
        
        mainView.monthView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                //                vc.changeDate(date: date)
                vc.mainView.monthView.datePiceker.date = UserDefaults.date!
//                vc.viewModel.dateTextField.accept(date)
//                UserDefaults.date = CustomFormatter.setformatter(date: date)
                vc.viewModel.dateTextField.accept(date)
                print("monthView", date, UserDefaults.date)
            }.disposed(by: disposedBag)
        
        mainView.dateView.datePiceker.rx
            .date
            .withUnretained(self)
            .bind { vc, date in
                //                vc.changeDate(date: date)
                vc.mainView.dateView.datePiceker.date = UserDefaults.date!
//                UserDefaults.date = CustomFormatter.setformatter(date: date)
                print("dateView", date, UserDefaults.date)
                vc.viewModel.dateTextField.accept(date)
                
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

