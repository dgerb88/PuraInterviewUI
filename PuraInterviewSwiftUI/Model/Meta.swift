//
//  Meta.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


struct Meta: Codable {
    let id: String
    let uuid: String
    let sort: String
    let stems: [String]
    let offensive: Bool
}
