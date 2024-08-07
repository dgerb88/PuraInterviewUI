import SwiftUI

struct DictionarySearch: View {
    
    @StateObject var viewModel = ViewModel()
    @State var searchText = ""
    @State var wordResponse: WordResponse?
    @State var isOffensive = false
    @State var isDict = true
    var memes = ["dosEquis", "mordor", "futurama", "simpsons", "yoda"]
    @State var meme = ""
    @State var apiError: String?
    @State var threwError = false
    
    var body: some View {
        VStack {
            customPicker()
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    searchSection()
                    if let wordResponse {
                        wordResponseSection(wordResponse: wordResponse)
                    } else {
                        HStack {
                            Spacer()
                            EmptyView(color: isDict ? Color.puraTeal : Color.puraOrange)
                            Spacer()
                        }
                        .padding(.top, 80)
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
        .animation(.easeInOut, value: wordResponse)
        .onChange(of: isDict) {
            if !searchText.isEmpty {
                wordResponse = nil
                performSearchAndRespondInView()
            }
        }
        .onChange(of: searchText) {
            isOffensive = false
        }
        .alert("", isPresented: $threwError) {
            Button {
                threwError = false
            } label: {
                Text("Ok")
            }
        } message: {
            Text(apiError ?? "")
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

    func performSearchAndRespondInView() {
        Task {
            do {
                wordResponse = try await viewModel.performSearch(query: searchText, isDict: isDict)
                guard wordResponse != nil else { return }
                isOffensive = wordResponse!.meta.offensive
                meme = (isOffensive ? memes.randomElement() : "")!
            } catch {
                wordResponse = nil
                threwError = true
                switch error {
                case APIError.badURL:
                    apiError = "There was an error with the URL"
                case APIError.noData:
                    apiError = "No data was found for the search"
                case APIError.emptyQuery:
                    apiError = "Please type a word to begin search"
                case APIError.tooShort:
                    apiError = "The search must include at least 3 letters"
                case APIError.serverError:
                    apiError = "There was an error with the server, please try again later"
                default:
                    apiError = "An unknown error occurred"
                }
            }
        }
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
            Image(meme)
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
                    performSearchAndRespondInView()
                }
            Button {
                performSearchAndRespondInView()
            } label: {
                Text("Search")
            }
            .buttonStyle(.borderedProminent)
            .tint(isDict ? Color.puraTeal : Color.puraOrange)
        }
    }
    
    func customPicker() -> some View {
        HStack(spacing: 0) {
            Button {
                isDict = true
            } label: {
                TopPickerView(isActive: isDict, text: "Dictionary", color: Color.puraOrange)
            }
            Button {
                isDict = false
            } label: {
                TopPickerView(isActive: !isDict, text: "Thesaurus", color: Color.puraTeal)
            }
        }
        .background(isDict ? Color.puraTeal : Color.puraOrange)
        .frame(height: 60)
    }
}

#Preview {
    DictionarySearch()
}
