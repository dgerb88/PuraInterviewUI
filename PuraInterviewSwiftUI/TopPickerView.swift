//
//  TopPickerView.swift
//  PuraInterviewSwiftUI
//
//  Created by Dax Gerber on 8/7/24.
//

import SwiftUI

struct TopPickerView: View {
    
    var isActive: Bool
    var text: String
    var color: Color
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundStyle(isActive ? .white : color)
            Text(text)
                .font(.title3)
                .foregroundStyle(isActive ? .black : .white)
        }
        
    }
}

#Preview {
    TopPickerView(isActive: false, text: "Dictionary", color: Color.puraTeal)
}
