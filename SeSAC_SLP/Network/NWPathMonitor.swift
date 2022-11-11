//
//  NWPathMonitor.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/12.
//

//MARK: 네트워크 모델
import Network

final class NetworkMonitor {
    
    private let queue = DispatchQueue.global(qos: .background) // 백그라운드에서 네트워크상태 관찰
    private let monitor: NWPathMonitor // 네크워크 변화 감지하는 객체
    
    init() {
        monitor = NWPathMonitor() // 인스턴스 생성
        dump(monitor) // 덤형태로 출력
        print("🔗=================🔗")
    }
    
    //NWPath : 연결이 사용하거나 앱에서 사용할 수 있는 네트워크의 속성에 대한 정보가 포함된 객체.
//    pathUpdateHandler : 네트워크 업데이트를 핸들링
    func startMonitoring(statusUpdateHandelr: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                // 업데이트를 글로벌에서 감지하면 메인에 전달해주기 위해 탈츌~
                statusUpdateHandelr(path.status)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
