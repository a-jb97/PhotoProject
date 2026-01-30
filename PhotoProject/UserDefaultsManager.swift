//
//  UserDefaultsManager.swift
//  PhotoProject
//
//  Created by 전민돌 on 1/30/26.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let value: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.value }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}

class UserDefaultsManager {
    @UserDefault(key: "like", value: false)
    static var like: Bool
}
