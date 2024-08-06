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
    
    static let baseUrl = "https://www.dictionaryapi.com/api/v3/references/collegiate/json/"
    
    func fetchWord(query: String, _ completion: @escaping (Result<Data, APIError>) -> Void) {
        guard !query.isEmpty else {
            completion(.failure(.emptyQuery))
            return
        }
        
        guard query.count > 2 else {
            completion(.failure(.tooShort(query)))
            return
        }
        
        
        let requestURL = URLBuilder(baseURL: API.baseUrl, word: query.lowercased()).requestURLDict
        
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
