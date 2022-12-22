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
        AF.request("https://www.abbreviations.com/services/v2/syno.php?uid=10372&tokenid=EDC29k8h49mQsBxL&word=\(userWord)&format=json")
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success( _):
                    do {
                        guard let jsonData = dataResponse.data else { return }
                        let decoder = JSONDecoder()
                        let synonym = try decoder.decode(ResultSynonym.self, from: jsonData)
                        DispatchQueue.main.async {
                            completion(.success(synonym.result))
                        }
                        return
                    } catch let error {
                        completion(.failure(.decodingError))
                        print(error, "ERROR")
                        
                        return
                    }
                case .failure:
                    completion(.failure(.decodingError))
                    print(completion)
                }
            }
    }
    
    func fetchRhymes(_ userWord: String, completion: @escaping(Result<String, NetworkError>) -> Void) {
        AF.request("https://www.abbreviations.com/services/v2/rhymes.php?uid=10372&tokenid=EDC29k8h49mQsBxL&term=\(userWord)&format=json")
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
                        completion(.failure(.decodingError))
                        print(error)
                    
                        return
                    }
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
    }
}
    
