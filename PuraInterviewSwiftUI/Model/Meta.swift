//
//  Meta.swift
//  SampleApp
//
//  Created by natehancock on 6/28/22.
//

import Foundation


struct Meta: Codable {
    let id: String
    let syns: [[String]]?
    let ants: [[String]]?
    let offensive: Bool
}

