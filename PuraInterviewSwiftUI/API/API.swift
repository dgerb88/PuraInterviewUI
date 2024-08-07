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

    func fetchWord(query: String, isDict: Bool) async throws -> Data {
        guard !query.isEmpty else {
            throw APIError.emptyQuery
        }
        
        guard query.count > 2 else {
            throw APIError.tooShort
        }
        
        var requestURL = URLBuilder(baseURL: API.dictUrl, word: query.lowercased()).requestURLDict
        if !isDict {
            requestURL = URLBuilder(baseURL: API.thesUrl, word: query.lowercased()).requestURLThes
        }
        
        guard let url = URL(string: requestURL) else {
            throw APIError.badURL
        }
        
        let request = URLRequest(url: url)
        
        print("Fetching from: ", request.url?.absoluteString ?? "")        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
    
        return data
    }
}
