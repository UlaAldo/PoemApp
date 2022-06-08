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
    
    
    func fetchSynonym(with userWord: String, completion: @escaping([Synonym]) -> Void) {
    guard let url = URL(string: "https://www.abbreviations.com/services/v2/syno.php?uid=10372&tokenid=EDC29k8h49mQsBxL&word=\(userWord)&format=json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
                       guard let data = data else {
                           print(error?.localizedDescription ?? "No error description")
                           return
                       }
                       do {
                           let synonym = try JSONDecoder().decode(ResultSynonym.self, from: data)
                           DispatchQueue.main.async {
                               print(synonym.result)
                               completion(synonym.result)
                           }
                       } catch let error {
                           print(error.localizedDescription)
                       }
                   }.resume()
               }
    
    func fetchRhymes(with userWord: String, completion: @escaping(String) -> Void) {
    guard let url = URL(string: "https://www.abbreviations.com/services/v2/rhymes.php?uid=10372&tokenid=EDC29k8h49mQsBxL&term=\(userWord)&format=json") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
                       guard let data = data else {
                           print(error?.localizedDescription ?? "No error description")
                           return
                       }
                       do {
                           let rhyme = try JSONDecoder().decode(Rhymes.self, from: data)
                           DispatchQueue.main.async {
                               print(rhyme.rhymes)
                               completion(rhyme.rhymes)
                           }
                       } catch let error {
                           print(error.localizedDescription)
                       }
                   }.resume()
               }
}
    
