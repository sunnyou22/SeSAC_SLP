//
//  DateFormatter.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/11.
//

import Foundation

struct CustomFormatter {
    
    static let ko = Locale(identifier:"ko_KR")
    
    //MARK: - 데이트포맷터
    
    //시간 24시간 형태
    static func setformatter(date: Date) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = CustomFormatter.ko
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        let str = formatter.string(from: date)
    
        return formatter.date(from: str)
    }
    
    
}
