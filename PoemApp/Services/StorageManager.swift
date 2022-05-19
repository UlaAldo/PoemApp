//
//  DataManager.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 17/05/22.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "poems"
    
    private init() {}
    
    func save(poem: String) {
        var poems = fetchPoems()
        poems.append(poem)
        userDefaults.set(poems, forKey: key)
    }
    
    func fetchPoems() -> [String] {
        if let poems = userDefaults.value(forKey: key) as? [String] {
            return poems
        }
        
        return []
    }
}
