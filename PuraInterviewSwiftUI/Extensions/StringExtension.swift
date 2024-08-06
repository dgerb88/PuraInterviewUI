//
//  StringExtension.swift
//  PuraInterviewSwiftUI
//
//  Created by Dax Gerber on 8/6/24.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
