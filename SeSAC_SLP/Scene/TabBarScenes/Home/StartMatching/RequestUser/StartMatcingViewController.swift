//
//  StartMatcingViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/26.
//

import UIKit
import RxSwift

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
        
        switch type {
        case .near:
            view.backgroundColor = .lightGray
        case .request:
            view.backgroundColor = .darkGray
        }
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 데이터 가져오기
        viewModel.fetchData()
        
        // 플레이스 홀더
        if viewModel.data.value.isEmpty {
            mainView.tableView.isHidden = true
        } else {
            mainView.tableView.isHidden = false
        }
    }
    
    func bind() {
        
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
        var titletitleStackView = cell.cardView.expandableView.titleStackView
        var wishStudy = cell.cardView.expandableView.whishStudyView
        var review =  cell.cardView.expandableView.reviewLabel
        
        name.text = viewModel.data.value[indexPath.row].nick
        review.text = viewModel.data.value[indexPath.row].reviews.last
       
        cell.cardView.expandableView.isHidden = hidden // 암튼 일케하면 되긴함

        let test = (cell.cardView.expandableView.titleStackView.rightVerticalStackView.arrangedSubviews + cell.cardView.expandableView.titleStackView.leftVerticalStackView.arrangedSubviews).sorted { $0.tag < $1.tag }
        
        
        
        // 이렇게 하면 쌍으로 나옴
        let zip = zip(test, viewModel.data.value[0].reputation)
        print(zip, test)
        zip.forEach { (view, value) in
            print(view.tag, value)
            view.backgroundColor = viewModel.reputationValid(value) ? .setBrandColor(color: .green) : .clear
        }
        /*
         data가 0이 아닌 애들을 색전환시켜주면 됨
         -> 유효성 판단인거
         */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hidden = !hidden // 여기서 불값 받음
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


extension StartMatcingViewController {
    //MARK: - 뷰컨 타입
    enum Vctype {
        case near
        case request
        
        var title: String {
            switch self {
            case .near:
                return "주변 새싹"
            case .request:
                return "받은 요청"
            }
        }
    }
}
