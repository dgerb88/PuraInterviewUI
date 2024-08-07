//
//  APIError.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


enum APIError: Error {
    case badURL
    case noData
    case serverError
    case emptyQuery
    case tooShort
}
