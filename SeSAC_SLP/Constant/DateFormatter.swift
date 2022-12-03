//
//  DateFormatter.swift
//  SeSAC_SLP
//
//  Created by 방선우 on 2022/11/11.
//

import Foundation

struct CustomFormatter {
    static let shared = CustomFormatter()
    let ko = Locale(identifier:"ko_KR")
    //MARK: - 데이트포맷터
    
    //시간 24시간 형태
    func setformatter(date: Date) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = ko
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let str = formatter.string(from: date)
        
        return formatter.date(from: str)
    }
    
    func setformatterToString(_ value: Date) -> String? {
        let formatter = DateFormatter()
        formatter.locale = ko
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return formatter.string(from: value)
    }
    
    func setformatterToDate(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = ko
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return formatter.date(from: value)
    }
    
    
//    func setMessaage(date: Date) -> String {
//
//        let formatter = DateFormatter()
//        formatter.locale = ko
//        formatter.dateFormat = "a hh:mm"
//    }
}
/*
 //시간 24시간 형태
 static func setformatter<T>(_ value: T) -> T? {
     let formatter = DateFormatter()
     formatter.locale = CustomFormatter.ko
     formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
     
     if T.self == Date.self {
         return formatter.string(from: value as! Date) as? T
     } else if T.self == String.self {
         return formatter.date(from: value as! String) as? T
     } else {
         
     }
 */
    
//}
