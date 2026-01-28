//
//  DateFormatter.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/28/26.
//

import Foundation

final class DateFormat {
    static let shared = DateFormat()
    
    private init() {  }
    
    let dateFormat = DateFormatter()
    
    func makeStringToDate(_ stringDate: String) -> Date {
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return dateFormat.date(from: stringDate) ?? Date()
    }
    
    func makeDateToString(_ date: Date) -> String {
        dateFormat.dateFormat = "yyyy년 M월 d일"
        
        return dateFormat.string(from: date)
    }
}
