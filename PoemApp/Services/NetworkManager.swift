//
//  NetworkManager.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 12/05/22.
//

import Foundation
import Alamofire


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func fetchSynonym(_ userWord: String, completion: @escaping(Result<[Synonym], NetworkError>) -> Void) {
        guard let url = URL(string: "https://www.abbreviations.com/services/v2/syno.php?uid=10372&tokenid=EDC29k8h49mQsBxL&word=\(userWord)&format=json") else { return }
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success( _):
                    do {
                        guard let jsonData = dataResponse.data else { return }

                        let decoder = JSONDecoder()
                        let synonym = try decoder.decode(ResultSynonym.self, from: jsonData)
                        completion(.success(synonym.result))
                       
                        return
                    } catch let error {
                        print(error)
                    
                        return
                    }
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    func fetchRhymes(_ userWord: String, completion: @escaping(Result<String, NetworkError>) -> Void) {
        guard let url = URL(string: "https://www.abbreviations.com/services/v2/rhymes.php?uid=10372&tokenid=EDC29k8h49mQsBxL&term=\(userWord)&format=json") else { return }
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success( _):
                    do {
                        guard let jsonData = dataResponse.data else { return }

                        let decoder = JSONDecoder()
                        let rhyme = try decoder.decode(Rhymes.self, from: jsonData)
                        completion(.success(rhyme.rhymes))
                       
                        return
                    } catch let error {
                        print(error)
                    
                        return
                    }
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
//    func fetchRhymes(with userWord: String, completion: @escaping(String) -> Void) {
//    guard let url = URL(string: "https://www.abbreviations.com/services/v2/rhymes.php?uid=10372&tokenid=EDC29k8h49mQsBxL&term=\(userWord)&format=json") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//                       guard let data = data else {
//                           print(error?.localizedDescription ?? "No error description")
//                           return
//                       }
//                       do {
//                           let rhyme = try JSONDecoder().decode(Rhymes.self, from: data)
//                           DispatchQueue.main.async {
//                               print(rhyme.rhymes)
//                               completion(rhyme.rhymes)
//                           }
//                       } catch let error {
//                           print(error.localizedDescription)
//                       }
//                   }.resume()
//               }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
    }
}
    
