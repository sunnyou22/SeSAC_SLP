//
//  ShopContainedViewController.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/12/06.
//

import UIKit

import StoreKit

//MARK: 포함되는 뷰컨
class ShopContainedViewController: BaseViewController, Bindable {

    var vctype: Vctype
    
    init(vctype: Vctype) {
        self.vctype = vctype
        super.init(nibName: nil, bundle: nil)
    }
    
    var mainview = ShopContainerView()
    
    var product: SKProduct?
    lazy var viewModel = ShopViewModel(vctype: vctype)
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        requestProductDat(productIdentifiers: viewModel.productIdentifiers) { // 상품정보요청
            print("===+++++++++++++====")
            mainview.collectionView.delegate = self
            mainview.collectionView.dataSource = self
            mainview.collectionView.reloadData()
        }
        
    }
    
    func bind() {

    }
}

extension ShopContainedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch vctype {
        case .sesac:
            print(viewModel.productArray.value.0, viewModel.productArray.value.1.count + 1, "------------------------------------")
           return (viewModel.productArray.value.1.count + 1)
        case .backgruond:
            print(viewModel.productArray.value.0, viewModel.productArray.value.1.count + 1, "------------------------------------")
            return (viewModel.productArray.value.1.count + 1)
          
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch vctype {
        case .sesac:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacCollectionViewCell.reuseIdentifier, for: indexPath) as? SesacCollectionViewCell else { return UICollectionViewCell() }
            switch indexPath.item {
            case 0:
                cell.sesac.image = UIImage(named: Sesac_Face.sesac_face_1.str)
                cell.nameLbl.text = "기본 새싹"
                return cell
            case ...viewModel.productArray.value.1.count:
                cell.sesac.image = UIImage(named: Sesac_Face.allCases[indexPath.item].str)
                cell.sesac.image = UIImage(named: Sesac_Face.allCases[indexPath.item].str)
                cell.nameLbl.text = viewModel.productArray.value.1[indexPath.item - 1].localizedTitle
                cell.explanation.text = viewModel.productArray.value.1[indexPath.item - 1].localizedDescription
                cell.priceBtn.setTitle("2000", for: .normal)
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
                return cell
            case ...viewModel.productArray.value.1.count:
                cell.background.image = UIImage(named: SeSac_Background.allCases[indexPath.item].str)
                cell.nameLbl.text = viewModel.productArray.value.1[indexPath.item - 1].localizedTitle
                cell.explanation.text = viewModel.productArray.value.1[indexPath.item - 1].localizedDescription
                cell.priceBtn.setTitle("2000", for: .normal)
                return cell
            default:
                cell.background.image = UIImage(named: "searchPlaceholder")
                return cell
            }
        }
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

extension ShopContainedViewController {
    
    // 상품조회 : productIdentifiers에 정의된 상품 ID에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
    func requestProductDat(productIdentifiers: Set<String>, completion: () -> Void) {
        //인앱결제가능한지 확이
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start() //인앱 상품 조회
            print("인앱 결제 가능")
        } else {
            print("In App Purchase Not Enabled")
        }
        completion()
    }
}

extension ShopContainedViewController: SKProductsRequestDelegate {
    //3. 인앱 상품 정보 조회
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        var productArray = Array<SKProduct>()
        
        if products.count > 0 {
            
            for i in products {
                productArray.append(i)
                product = i //옵션: 셀에서 구매하기 버튼 클릭
                viewModel.productArray.accept((vctype, productArray))
                print(i.localizedTitle, i.price, i.priceLocale, i.productIdentifier, i.localizedDescription)
            }
            
        } else {
            print("No Product Found") // 계약 업데이트, 유료 계약 ㄴㄴ .Capabilities ㄴㄴ 일때
        }
    }
}
