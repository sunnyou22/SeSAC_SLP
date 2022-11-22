//
//  APIViewModel.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/19.
//

import Foundation

import RxCocoa
import RxSwift
import Alamofire
import FirebaseAuth

//manager로 넣어줄건지 고민해보기

final class CommonServerManager {
    
    let authValidCode = PublishRelay<AuthCredentialText>()
    let usererror = PublishRelay<ServerStatus.UserError>()
    let commonError = PublishRelay<ServerStatus.Common>()
    
    //MAKR: - 모델로 빼기
    func USerInfoNetwork(idtoken: String) {
        let api = SeSACAPI.getUserInfo
        
        Network.shared.requestSeSAC(type: GetUerIfo.self, url: api.url, parameter: nil, method: .get, headers: api.getheader(idtoken: idtoken)) { [weak self] response in
            
            switch response {
            case .success(let success):
                print("로그인 성공 혹은 유저 정보가져오기 성공 ✅", success)
                UserDefaults.getUerIfo = [success]
                self?.commonError.accept(.Success) // 이게 없음면 화면이 안넘어가는디
                /*
                 네트워크함수가 실행됐어 -> 통신을 시작하고 값을 가져왔어 -> 작업을 완료한뒤에 값을 뱉을건데 컴플리션핸들러가 그 역할을 해줌 -> 성공 실패의 값을 뱉어줌 후행클로저도 이때 실행이 될탠데 아래 핸들러 구문-> 이때 스테이터스 값으로 값을 핸들리을 하면서? 이벤트를 전달할 건데
                 먼가 후행클로저까지 실행되기 전에 네트워크가 유실되는 느낌
                 */
            case .failure(let error):
                print("실ㅍㅐ")
            }
            // 수정하자..에러. 온보딩에서 시점이 안맞음 탈출클로저라서 데이터 통신이 끝다고 아래구문을 부름
        } statusHandler: { [weak self] statusCode in
            
           
            
            switch commonError {
                
            case .Success:
                self?.commonError.accept(.Success)
            case .FirebaseTokenError:
                self?.commonError.accept(.FirebaseTokenError)
            case .NotsignUpUser:
                self?.commonError.accept(.NotsignUpUser)
            case .ServerError:
                self?.commonError.accept(.ServerError)
            case .ClientError:
                self?.commonError.accept(.ClientError)
            }
            
            switch userError {
            case .SignInUser:
                self?.usererror.accept(.SignInUser)
            case .InvaliedNickName:
                self?.usererror.accept(.InvaliedNickName)
            }
        }
    }
    
    // 공통요소로 빼기 -> 위치가 이동할 때마다 호출해줘야함
    func fetchMapData(lat: Double, long: Double, idtoken: String) {
        let api = SeSACAPI.searchSurroundings(lat: lat, long: long)
        Network.shared.requestSeSAC(type: SearchSurroundings.self, url: api.url, parameter: api.parameter, method: .post, headers: api.getheader(idtoken: idtoken)) { response in
            
            switch response {
            case .success(let success):
                dump(success)
                UserDefaults.searchData = [success]
                print(UserDefaults.searchData, " 🔴 🔴 🔴 인코딩이 잘 됐나요~")
                print("맵 좌표값에 대한 응답값 받기 성공 ✅")
            case .failure(let error):
                print("맵 좌표값 받기 에러 🔴", #file, #function)
                print(error)
            }
        } statusHandler: { [weak self] statusCode in
            
            guard let commonError = ServerStatus.Common(rawValue: statusCode) else { return }
            
            switch commonError {
            case .Success:
                self?.commonError.accept(.Success)
            case .FirebaseTokenError:
                self?.commonError.accept(.FirebaseTokenError)
            case .ServerError:
                self?.commonError.accept(.ServerError)
            case .ClientError:
                self?.commonError.accept(.ClientError)
            case .NotsignUpUser:
                self?.commonError.accept(.NotsignUpUser)
            }
        }
    }
}

