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
    
    func save(poem: Poem) {
        var poems = fetchPoems()
        poems.append(poem)
        userDefaults.set(poems, forKey: key)
    }
    
    func fetchPoems() -> [Poem] {
        if let poems = userDefaults.value(forKey: key) as? [Poem] {
            return poems
        }
        
        return []
    }
    
    func deletePoem(at index: Int) {
        var poems = fetchPoems()
        poems.remove(at: index)
        userDefaults.set(poems, forKey: key)
    }
}
