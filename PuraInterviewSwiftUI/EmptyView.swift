//
//  EmptyView.swift
//  PuraInterviewSwiftUI
//
//  Created by Dax Gerber on 8/7/24.
//

import SwiftUI

struct EmptyView: View {
    
    var color: Color
    
    var body: some View {
        
        VStack(alignment: .center) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Text("Search for a word above")
                .padding(.top, 30)
        }
        .foregroundStyle(color)
        .opacity(0.6)
        
    }
}

#Preview {
    EmptyView(color: .puraOrange)
}
