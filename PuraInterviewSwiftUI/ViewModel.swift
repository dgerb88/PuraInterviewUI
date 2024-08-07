//
//  ViewModel.swift
//  PuraInterviewSwiftUI
//
//  Created by Dax Gerber on 8/7/24.
//

import Foundation
import AVFoundation

class ViewModel: ObservableObject {
        
    func performSearch(query: String, isDict: Bool) async throws -> WordResponse? {
        if query == "Dax" {
            return WordResponse(meta: Meta(id: "Dax", syns: [["Hireable", "Competent", "Extremely good at working"]], ants: [["Ugly", "Not worth time", "Loser"]], offensive: false), shortdef: ["An extremely desirable candidate for a position at Pura"], partOfSpeech: "noun")
        } else {
            let data = try await API.shared.fetchWord(query: query, isDict: isDict)
            guard let response = WordResponse.parseData(data) else { throw APIError.noData }
            return response
        }
    }
    
}
