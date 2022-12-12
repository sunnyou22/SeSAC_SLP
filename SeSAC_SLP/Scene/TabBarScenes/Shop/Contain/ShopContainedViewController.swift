//
//  ShopContainedViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/06.
//

import UIKit

import StoreKit
import RxSwift
import RxCocoa

protocol Sendableitem: NSObject {
    func sendSesacimgStr(_ name: String)
    func sendBackgroundimgStr(_ name: String)
}

//MARK: 포함되는 뷰컨
class ShopContainedViewController: BaseViewController, Bindable {
    
    var vctype: Vctype
    
   weak var delegate: Sendableitem? // weak는 참조에만 쓰이는데 그럼 프로토콜 자체가 클래스에서만 쓰일수있도록 제약사항을 줘야함
    
    init(vctype: Vctype) {
        self.vctype = vctype
        super.init(nibName: nil, bundle: nil)
    }
    
    var mainview = ShopContainerView()
    
    lazy var viewModel = ShopContainerViewModel(vctype: vctype)
    let bag = DisposeBag()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestProductData(productIdentifiers: viewModel.productIdentifiers)// 상품정보요청
        
        bind()
        
        mainview.collectionView.delegate = self
        mainview.collectionView.dataSource = self
        
        switch vctype {
            
        case .sesac:
            mainview.backgroundColor = .brown
            mainview.collectionView.collectionViewLayout = mainview.configureSesacCollectionViewLayout()
        case .backgruond:
            mainview.backgroundColor = .lightGray
            mainview.collectionView.collectionViewLayout = mainview.configureBackCollectionViewLayout()
        }
        
        viewModel.myPurchaseInfo(idtoken: idToken) 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    func bind() {
//
//        viewModel.productarray
//            .bind { [weak self] _ in
//                LoadingIndicator.showLoading()
//                DispatchQueue.main.asyncAfter(deadline: .now().clamped(to: .), execute: <#T##Dispatch.DispatchWorkItem#>) {
//                    self?.mainview.collectionView.reloadData()
//                    LoadingIndicator.hideLoading()
//                }
//
//            }.disposed(by: bag)
//
//        viewModel.product
//
//            .asDriver()
//            .drive(mainview.collectionView.rx.items(cellIdentifier: SesacCollectionViewCell.reuseIdentifier, cellType: SesacCollectionViewCell.self)) {
//                item, ele, cell in

//            }.disposed(by: bag)
            
        
        viewModel.receiptValidationStatus
            .withUnretained(self)
            .bind { vc, status in
              
                switch status {
                case .success:
                    print("구매성공")
                    vc.viewModel.myPurchaseInfo(idtoken: vc.idToken) { _ in
                        vc.mainview.collectionView.reloadData()
                        LoadingIndicator.hideLoading()
                    }
                case .invalid:
                    print("검증실패")
                    LoadingIndicator.hideLoading()
                default:
                    print("기타오류")
                    LoadingIndicator.hideLoading()
                }
            }.disposed(by: bag)
    }
}

extension ShopContainedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch vctype {
        case .sesac:
            return (viewModel.productarray.value.1.count + 1)
        case .backgruond:
            return (viewModel.productarray.value.1.count + 1)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch vctype {
        case .sesac:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacCollectionViewCell.reuseIdentifier, for: indexPath) as? SesacCollectionViewCell else { return UICollectionViewCell() }
            
            switch indexPath.item {
            case 0:
                cell.priceBtn.tag = indexPath.item
                cell.sesac.image = UIImage(named: Sesac_Face.sesac_face_1.str)
                cell.priceBtn.configuration?.baseBackgroundColor = .setGray(color: .gray7)
                cell.nameLbl.text = "기본 새싹"
                cell.priceBtn.setTitle("보유", for: .normal)
                cell.isUserInteractionEnabled = false
                return cell
            case ...viewModel.productarray.value.1.count:
                cell.priceBtn.tag = indexPath.item
                cell.sesac.image = UIImage(named: Sesac_Face.allCases[indexPath.item].str)
                cell.sesac.image = UIImage(named: Sesac_Face.allCases[indexPath.item].str)
                cell.nameLbl.text = viewModel.productarray.value.1[indexPath.item - 1].localizedTitle
                cell.explanation.text = viewModel.productarray.value.1[indexPath.item - 1].localizedDescription
                
                for value in viewModel.myPurchaseInfo.value[0].sesacCollection {
                    if indexPath.item == value {
                        cell.priceBtn.setTitle("보유", for: .normal)
                        cell.priceBtn.configuration?.baseBackgroundColor = .setGray(color: .gray7)
                        break
                    } else {
                        cell.priceBtn.configuration?.baseBackgroundColor = .setBrandColor(color: .green)
                        cell.priceBtn.setTitle("\(viewModel.productarray.value.1[indexPath.item - 1].price)", for: .normal)
                        // cell 버튼 클릭
                        cell.priceBtn.addTarget(self, action: #selector(clickbutton), for: .touchUpInside)
                    }
                }
                
//                viewModel.myPurchaseInfo.value[0].sesacCollection.forEach { value in
//
//                }
                
             
                
                
//                cell.priceBtn.rx
//                    .tap
//                    .withUnretained(self)
//                    .asDriver(onErrorJustReturn: (self, print("가격버튼 구독")))
//                    .drive { vc, _ in
//                        if viewModel.myPurchaseInfo.value[0].sesacCollection[<#Int#>] vc.viewModel.myPurchaseInfo.value[0].backgroundCollection.dropFirst().contains(cell.priceBtn.tag), indexPath.item ==  {
//                            cell.priceBtn.backgroundColor = .setGray(color: .gray2)
//                            cell.priceBtn.setTitle("보유", for: .normal)
//                        } else {
//                            cell.priceBtn.backgroundColor = .setBrandColor(color: .green)
//                            cell.priceBtn.setTitle("\(vc.viewModel.productArray.value.1[indexPath.item - 1].price)", for: .normal)
//                        }
//                    }.disposed(by: bag)
                return cell
            default:
                cell.sesac.image = UIImage(named: "searchPlaceholder")
                return cell
            }
            
        case .backgruond:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundCollectionViewCell.reuseIdentifier, for: indexPath) as? BackgroundCollectionViewCell else { return UICollectionViewCell() }
            
            switch indexPath.item {
            case 0:
                cell.background.image = UIImage(named: SeSac_Background.sesac_background_1.str)
                cell.nameLbl.text = "기본 새싹"
                cell.priceBtn.setTitle("보유", for: .normal)
                cell.priceBtn.configuration?.baseBackgroundColor = .setGray(color: .gray7)
                cell.isUserInteractionEnabled = false
                return cell
            case ...viewModel.productarray.value.1.count:
                cell.priceBtn.tag = indexPath.item
                cell.background.image = UIImage(named: SeSac_Background.allCases[indexPath.item].str)
                cell.nameLbl.text = viewModel.productarray.value.1[indexPath.item - 1].localizedTitle
                cell.explanation.text = viewModel.productarray.value.1[indexPath.item - 1].localizedDescription
                cell.priceBtn.setTitle("2000", for: .normal)
                
                viewModel.myPurchaseInfo.value[0].backgroundCollection.forEach { value in
                    if indexPath.item == value {
                        cell.priceBtn.setTitle("보유", for: .normal)
                        cell.priceBtn.configuration?.baseBackgroundColor = .setGray(color: .gray7)
                    } else {
                        cell.priceBtn.configuration?.baseBackgroundColor = .setBrandColor(color: .green)
                        cell.priceBtn.setTitle("\(viewModel.productarray.value.1[indexPath.item - 1].price)", for: .normal)
                        cell.priceBtn.addTarget(self, action: #selector(clickbutton), for: .touchUpInside)
                    }
                }
                return cell
            default:
                cell.isUserInteractionEnabled = false
                cell.background.image = UIImage(named: "searchPlaceholder")
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch vctype {
        case .sesac:
            delegate?.sendSesacimgStr(Sesac_Face.allCases[indexPath.item].str)
        case .backgruond:
            delegate?.sendBackgroundimgStr(SeSac_Background.allCases[indexPath.item].str)
        }
    }
    
    @objc func clickbutton(_ sender: UIButton) {
       
        LoadingIndicator.showLoading()
        viewModel.buy(index: sender.tag - 1)
        print(viewModel.productIdentifiers.sorted()[sender.tag - 1])
    }
}

extension ShopContainedViewController {
    //뷰컨 타입
    enum Vctype: Int, CaseIterable {
        case sesac
        case backgruond
        
        var title: String {
            switch self {
            case .sesac:
                return "새싹"
            case .backgruond:
                return "배경"
            }
        }
        
//        var button
    }
    
    /*
     카테고리가 증가한다고 했을 때
     페이지 안에 들어가는 이미지, 네임, 가격 등 하위항목을 Struct 내부에 enum 케이스로 정리해보는건
     
     구조를 바꿔서 bind로 컬렉션뷰를 구현한다고 했을 때:
     시점 문제가 해결되는게 맞을까 이미지가 더 많다면? 데이터가 다 받아와지는 시점에 유저 액션을 받을수있도록 해야하나
     그럼 현 구조에서 배경아이템을 구매한다고하면 데이터가 받아와지지 않았는데 인덱스에 접근하는 문제는 aysncAfter로 아니지 디스패치 그룹 사용해보기
     */
}



