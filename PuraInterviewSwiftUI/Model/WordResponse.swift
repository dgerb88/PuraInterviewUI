//
//  WordResponse.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


struct WordResponse: Codable, Equatable {
    
    static func == (lhs: WordResponse, rhs: WordResponse) -> Bool {
        lhs.meta.id == rhs.meta.id
    }
    
    let meta: Meta
    let shortdef: [String]
    let partOfSpeech: String
    
    enum CodingKeys: String, CodingKey {
        case meta
        case shortdef
        case partOfSpeech = "fl"
    }
    
    var word: Word {
        return Word(text: meta.id, 
                    definitions: shortdef, 
                    synonyms: meta.syns?.first,
                    antonyms: meta.ants?.first
        )
    }
    
    static func parseData(_ data: Data) -> WordResponse? {
        do {
            let response = try JSONDecoder().decode([WordResponse].self, from: data)
            return response.first
        } catch {
            print("WORD RESPONSE ERROR: ", error.localizedDescription)
        }
        return nil
    }
}


