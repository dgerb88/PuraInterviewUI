//
//  ContentView.swift
//  PuraInterviewSwiftUI
//
//  Created by Dax Gerber on 8/5/24.
//

import SwiftUI

struct DictionarySearch: View {
    
    @State var searchText = ""
    @State var wordResponse: WordResponse?
    @State var isOffensive = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    TextField("Search dictionary", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        //TODO: need to shorten this
                        
                        API.shared.fetchWord(query: searchText) { response in
                            switch response {
                            case .success(let data):
                                guard let response = WordResponse.parseData(data) else { return }
                                wordResponse = response
                                guard wordResponse != nil else { return }
                                isOffensive = wordResponse!.meta.offensive
                            case .failure(let error):
                                wordResponse = nil
                                print("NETWORK ERROR: ", error.localizedDescription)
                            }
                        }
                    } label: {
                        Text("Search")
                    }.buttonStyle(.borderedProminent)
                    
                }
                if let wordResponse {
                    
                    //TODO: Insert phonetic way of saying it here
                    if isOffensive {
                        //TODO: Definitely do something better than this
                        Text("This is offensive to me")
                    }
                    Text(wordResponse.fl)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                    Text("Definitions:")
                        .font(.title3)
                    ForEach(Array(wordResponse.word.definitions.enumerated()), id: \.1.self) { index, definition in
                        Text("\(index + 1). ") + Text(definition.capitalizingFirstLetter())
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    DictionarySearch()
}
