//
//  UserDefaultsManager.swift
//  LessonFileManager
//
//  Created by Сергей Штейман on 02.04.2022.
//

import Foundation

// MARK: - UserDefaultsKey
enum UserDefaultsKey: String {
    case userName = "userName"
    case userPhone = "userPhone"
    case userGender = "userGender"
    case userAge = "userAge"
    case isNoticeEnabled = ""
}

// MARK: - UserDefaultsManager
final class UserDefaultsManager {
    
    static func save(_ value: Any, for key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func fetch<T: Decodable>(type: T.Type, for key: UserDefaultsKey) -> T? {
        UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
}
