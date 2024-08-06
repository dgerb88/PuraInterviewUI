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
    @State var isDict = true
    
    var body: some View {
        VStack {
            Picker("", selection: $isDict) {
                Text("Dictionary").tag(true)
                Text("Thesaurus").tag(false)
            }
            .pickerStyle(.segmented)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        TextField("Search", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                performSearchWithEasterEgg()
                            }
                        Button {
                            performSearch()
                        } label: {
                            Text("Search")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(isDict ? .blue : .teal)

                        
                    }
                    if let wordResponse {
                        
                        //TODO: Insert phonetic way of saying it here
                        if isOffensive {
                            //TODO: Definitely do something better than this
                            Text("This is offensive to me")
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text(wordResponse.partOfSpeech)
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.vertical)
                            
                            if isDict {
                                definitions(wordResponse: wordResponse)
                            } else {
                                HStack(alignment: .top) {
                                    synonyms(wordResponse: wordResponse)
                                    Spacer()
                                    antonyms(wordResponse: wordResponse)
                                    Spacer()
                                }
                            }
                        }.padding(.leading)
                        
                    }
                }
                .padding()
            }
        }
        .animation(.easeInOut, value: isDict)
    }
    
    func definitions(wordResponse: WordResponse) -> some View {
        VStack(alignment: .leading,spacing: 10) {
            Text(wordResponse.word.definitions.count == 1 ? "Definition:" : "Definitions:")
                .font(.title3)
                .padding(.bottom, 10)
                .fontWeight(.medium)
            ForEach(Array(wordResponse.word.definitions.enumerated()), id: \.1.self) { index, definition in
                Text("\(index + 1). ") + Text(definition.capitalizingFirstLetter())
            }
        }
    }
    
    func synonyms(wordResponse: WordResponse) -> some View {
        VStack(alignment: .leading) {
            Text(wordResponse.word.synonyms?.count == 1 ? "Synonym:" : "Synonyms:")
                .font(.title3)
                .padding(.bottom, 10)
                .fontWeight(.medium)
            ForEach(Array((wordResponse.word.synonyms ?? []).enumerated()), id: \.1.self) { index, synonym in
                Text("\(index + 1). ") + Text(synonym.capitalizingFirstLetter())
            }
        }
    }
    
    func antonyms(wordResponse: WordResponse) -> some View {
        VStack(alignment: .leading) {
            Text(wordResponse.word.antonyms?.count == 1 ? "Antonym:" : "Antonyms:")
                .font(.title3)
                .padding(.bottom, 10)
                .fontWeight(.medium)
            ForEach(Array((wordResponse.word.antonyms ?? []).enumerated()), id: \.1.self) { index, antonym in
                Text("\(index + 1). ") + Text(antonym.capitalizingFirstLetter())
            }
        }
    }

    func performSearch() {
        API.shared.fetchWord(query: searchText, isDict: isDict) { response in
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
    }
    
    func performSearchWithEasterEgg() {
        if searchText == "Dax" {
            wordResponse = WordResponse(meta: Meta(id: "Dax", syns: [["Hireable", "Competent", "Extremely good at working"]], ants: [["Ugly", "Not worth time", "Loser"]], offensive: false), shortdef: ["An extremely desirable candidate for a position at Pura"], partOfSpeech: "noun")
        } else {
            performSearch()
        }
    }
    
    
}

#Preview {
    DictionarySearch()
}
