//
//  NetworkManager.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 12/05/22.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    var userRequest = "love"
    
    func fetchSynonym(completion: @escaping([Synonym]) -> Void) {
    guard let url = URL(string: "https://www.abbreviations.com/services/v2/syno.php?uid=10372&tokenid=EDC29k8h49mQsBxL&word=pain&format=json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
                       guard let data = data else {
                           print(error?.localizedDescription ?? "No error description")
                           return
                       }
                       do {
                           let synonym = try JSONDecoder().decode(ResultSynonym.self, from: data)
                           DispatchQueue.main.async {
                               completion(synonym.result)
                           }
                       } catch let error {
                           print(error.localizedDescription)
                       }
                   }.resume()
               }
    
    func fetchRhymes(completion: @escaping(Rhymes) -> Void) {
    guard let url = URL(string: "https://www.abbreviations.com/services/v2/rhymes.php?uid=10372&tokenid=EDC29k8h49mQsBxL&term=pain&format=json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
                       guard let data = data else {
                           print(error?.localizedDescription ?? "No error description")
                           return
                       }
                       do {
                           let rhyme = try JSONDecoder().decode(Rhymes.self, from: data)
                           DispatchQueue.main.async {
                               print(rhyme)
                               completion(rhyme)
                           }
                       } catch let error {
                           print(error.localizedDescription)
                       }
                   }.resume()
               }
}
    
