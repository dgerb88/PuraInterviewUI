//
//  URLBuilder.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


struct URLBuilder {
    var baseURL: String
    var word: String

    var requestURLDict: String {
        let url = baseURL + word + "?key=" + Tokens.apiKeyDict
        return url
    }
    
//    var requestURLThes: String { "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/umpire?key=59a05a64-94df-4983-a3b0-a691ea99fcdb"
//    }
}
