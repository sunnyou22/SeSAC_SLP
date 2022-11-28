//
//  StartMatcingViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit
import RxSwift

//델리케이트로 값전달해보귀
class StartMatcingViewController: BaseViewController, Bindable {
    
    var type: Vctype
    let mainView = StartMatchingView()
    
    var hidden = false
  
    let viewModel: StartMatchingViewModel
    let bag = DisposeBag() // 모델로 어떻게 뺄지 생각해보기
    let commonAPIviewModel = CommonServerManager()
    
    // 탭맨에서 초기화됨
    init(type: Vctype, viewModel: StartMatchingViewModel) {
        self.type = type
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 데이터 가져오기
        viewModel.fetchData()
        
        if viewModel.data.value.isEmpty {
            mainView.tableView.isHidden = true
            mainView.stackView.isHidden = false
        } else {
            mainView.tableView.isHidden = false
            mainView.stackView.isHidden = true
        }
    }
    
    func bind() {
        let input = StartMatchingViewModel.Input(tapChangeStudyBtn: mainView.changeStudyButton.rx.tap, refreshButton: mainView.refreshButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.tapChangeStudyBtn
            .drive { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: bag)
        
        output.refreshButton
            .drive { [weak self] _ in
                //                <#code#>
            }.disposed(by: bag)
    }
    
    override func configure() {
        super.configure()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension StartMatcingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.data.value.count, "viewModel.data.value.count==========")
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StartMatchingCollectionViewCell.reuseIdentifier, for: indexPath) as? StartMatchingCollectionViewCell else { return UITableViewCell()}
        var name = cell.cardView.nicknameView.nameLabel
        var titleStackView = cell.cardView.expandableView.titleStackView
        var wishStudy = cell.cardView.expandableView.whishStudyView
        var review =  cell.cardView.expandableView.reviewLabel
        
        name.text = viewModel.data.value[indexPath.row].nick
        review.text = viewModel.data.value[indexPath.row].reviews.last
        
        cell.requestButton.setTitle(type.buttonTitle, for: .normal)
        cell.requestButton.backgroundColor = type.buttonColor
        
     
        
        let sesacTitle = (titleStackView.rightVerticalStackView.arrangedSubviews + titleStackView.leftVerticalStackView.arrangedSubviews).sorted { $0.tag < $1.tag }
        
        // 이렇게 하면 쌍으로 나옴
        let zip = zip(sesacTitle, viewModel.data.value[0].reputation)
        print(zip, sesacTitle)
        zip.forEach { (view, value) in
            print(view.tag, value)
            view.backgroundColor = viewModel.reputationValid(value) ? .setBrandColor(color: .green) : .clear
        }
        
        
        // 컬렉션뷰 채택
        cell.cardView.expandableView.whishStudyView.collectionView.delegate = self
        cell.cardView.expandableView.whishStudyView.collectionView.dataSource = self
        cell.cardView.expandableView.whishStudyView.collectionView.collectionViewLayout = cell.cardView.expandableView.whishStudyView.configureCollectionViewLayout()
        
    
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))

        cell.cardView.nicknameView.addGestureRecognizer(tapGesture)
        cell.cardView.expandableView.isHidden = hidden // 암튼 일케하면 되긴함
        
        viewModel.test
            .withUnretained(self)
            .bind { vc, bool in
                tableView.reloadRows(at: [indexPath], with: .automatic)
                    print("didselect")
            }.disposed(by: bag)
     
        //얼럿
        cell.requestButton.addTarget(self, action: #selector(request), for: .touchUpInside)
        
        return cell
    }

    // 3. this method is called when a tap is recognized
    @objc func handleTap(sender: UITapGestureRecognizer) {
        hidden = !hidden
        viewModel.test.accept(hidden)
        print("tap")
    }

    @objc func request() {
        print("버튼 눌리야?")
        let vc = StartMatchingCustomAlert(type: type)
        vc.modalPresentationStyle = .formSheet
        vc.data = viewModel.data.value
        present(vc, animated: true)
    }
}

extension StartMatcingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.value[0].studylist.count
    }
    
    // 왜 안들어오는데
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollecitionViewCell.reuseIdentifier, for: indexPath) as? SearchCollecitionViewCell else { return UICollectionViewCell() }
        cell.xbutton.isHidden = true
        cell.label.text = viewModel.data.value[0].studylist[indexPath.item]
        return cell
    }
}
