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

//MARK: 포함되는 뷰컨
class ShopContainedViewController: BaseViewController, Bindable {
    
    var vctype: Vctype
    
    init(vctype: Vctype) {
        self.vctype = vctype
        super.init(nibName: nil, bundle: nil)
    }
    
    var mainview = ShopContainerView()
    
    lazy var viewModel = ShopViewModel(vctype: vctype)
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
        
        viewModel.USerInfoNetwork(idtoken: idToken)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    func bind() {
        
        viewModel.productarray
            .bind { [weak self] _ in
                DispatchQueue.main.async {
                    self?.mainview.collectionView.reloadData()
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
                
                viewModel.myPurchaseInfo.value[0].sesacCollection.forEach { value in
                    if indexPath.item == value {
                        cell.priceBtn.setTitle("보유", for: .normal)
                        cell.priceBtn.configuration?.baseBackgroundColor = .setGray(color: .gray7)
                    } else {
                        cell.priceBtn.configuration?.baseBackgroundColor = .setBrandColor(color: .green)
                        cell.priceBtn.setTitle("\(viewModel.productarray.value.1[indexPath.item - 1].price)", for: .normal)
                        // cell 버튼 클릭
                        cell.priceBtn.addTarget(self, action: #selector(clickbutton), for: .touchUpInside)
                    }
                }
                
             
                
                
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
    
    @objc func clickbutton(_ sender: UIButton) {
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
    }
}



