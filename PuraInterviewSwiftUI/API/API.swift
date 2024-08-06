//
//  API.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation

class API {
    static let shared = API()
    let session = URLSession.shared
    
    static let dictUrl = "https://www.dictionaryapi.com/api/v3/references/collegiate/json/"
    static let thesUrl = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/"
    
    func fetchWord(query: String, isDict: Bool , _ completion: @escaping (Result<Data, APIError>) -> Void) {
        guard !query.isEmpty else {
            completion(.failure(.emptyQuery))
            return
        }
        
        guard query.count > 2 else {
            completion(.failure(.tooShort(query)))
            return
        }
        
        var requestURL = URLBuilder(baseURL: API.dictUrl, word: query.lowercased()).requestURLDict
        if !isDict {
            requestURL = URLBuilder(baseURL: API.thesUrl, word: query.lowercased()).requestURLThes
        }
        
        guard let url = URL(string: requestURL) else {
            completion(.failure(.badURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        print("Fetching from: ", request.url?.absoluteString ?? "")
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
            

        }.resume()
        
    }
    
}
