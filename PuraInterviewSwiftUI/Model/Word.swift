//
//  Word.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


struct Word: Codable {
    var text: String
    var definitions: [String]
    var synonyms: [String]?
    var antonyms: [String]?
}
