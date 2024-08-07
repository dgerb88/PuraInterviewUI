import SwiftUI

struct DictionarySearch: View {
    
    @State var searchText = ""
    @State var wordResponse: WordResponse?
    @State var isOffensive = false
    @State var isDict = true
    var meme = ["dosEquis", "pikachu", "mordor", "futurama", "simpsons", "yoda"].randomElement()
    
    var body: some View {
        VStack {
            Picker("", selection: $isDict) {
                Text("Dictionary")
                    .tag(true)
                Text("Thesaurus")
                    .tag(false)
            }
            .pickerStyle(.segmented)
            .frame(height: 50)
            .background(isDict ? Color.blue : Color.teal)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    searchSection()
                    if let wordResponse {
                        wordResponseSection(wordResponse: wordResponse)
                    }
                    if isOffensive {
                        offensiveSection()
                            .padding(.top)
                    }
                }
                .padding()
            }
        }
        .animation(.easeInOut(duration: 1), value: isOffensive)
        .animation(.easeInOut, value: isDict)
        .onChange(of: isDict) {
            if !searchText.isEmpty {
                wordResponse = nil
                performSearchWithEasterEgg()
            }
        }
        .onChange(of: searchText) {
            isOffensive = false
        }
    }
    
    func wordResponseSection(wordResponse: WordResponse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(wordResponse.partOfSpeech)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.vertical)
            
            if isDict {
                definitionsSection(wordResponse: wordResponse)
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

    
    func definitionsSection(wordResponse: WordResponse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
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
    
        
    func offensiveSection() -> some View {
        Group {
            Image(meme!)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
            Text("This has been deemed offensive, shame on you for searching for it")
                
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    func searchSection() -> some View {
        HStack {
            TextField("Search", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    withAnimation(.easeIn) {
                        performSearchWithEasterEgg()
                    }
                }
            Button {
                withAnimation(.easeIn) {
                    performSearchWithEasterEgg()
                }
            } label: {
                Text("Search")
            }
            .buttonStyle(.borderedProminent)
            .tint(isDict ? .blue : .teal)
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
