//
//  ModelView.swift
//  PokemonList
//
//  Created by kamil on 13.07.2021.
//

import SwiftUI
import Combine




class JsonPlaceHolderModelView: ObservableObject {
    
    @Published var post: [Post] = []
    @Published var comments: [Comment] = []
    @Published var albums: [Albums] = []
    @Published var photo: [Photos] = []
    @Published var todos: [Todos] = []
    @Published var user: [Users] = []
    @Published var adress: [Address] = []
    @Published var geo: [Geo] = []
    
    @Published var errorType: ErrorType?
    
    private let baseUrl = "https://jsonplaceholder.typicode.com"
    
    var cancellable: Set<AnyCancellable> = []
    var anyCancellable: AnyCancellable?
    
    
    init() {
        user.publisher
            .map{$0.address}
            .assign(to: &$adress)
        
        adress.publisher
            .map{$0.geo}
            .assign(to: &$geo)
    }
    
    // MARK: - functions
    
  func fetchPost() {
    guard let url = URL(string: "\(baseUrl)" + "\(EndPoint.posts.components)") else { return }
         anyCancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw ErrorType.unknowed
                }
                if (400...499).contains(urlResponse.statusCode) {
                    throw ErrorType.invalidUrl
                }
                if (500...599).contains(urlResponse.statusCode) {
                    throw ErrorType.noData
                }
                return data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .mapError { error -> ErrorType in
                if let responseError = error as? ErrorType {
                    return responseError
                } else {
                    return ErrorType.invalidUrl
                }
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [unowned self] completion in
                switch completion {
                case .finished:
                      break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [unowned self] value in
                self.post = value
            })
    }
    
    
    
    func fetchWithOutCombine() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
               if let decoder = try? JSONDecoder().decode([Post].self, from: data) {
                DispatchQueue.main.async {
                    self.post = decoder
                }
                }
            }
        }.resume()
    }
    
    func shortCombineJustData() {
        guard let url = URL(string: "\(baseUrl)" + "\(EndPoint.posts.components)") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { value in
                self.post = value
            })
            .store(in: &cancellable)
    }
    
    
    
    
    
    // MARK: - Enum points
    
    enum EndPoint: Error {
        case posts
        case comments
        case albums
        case photos
        case todos
        case users
        
        var components: String {
            switch self {
            
            case .posts:
                return "/posts"
            case .comments:
                return "/comments"
            case .albums:
                return "/albums"
            case .photos:
                return "/photos"
            case .todos:
                return "/todos"
            case .users:
                return "/users"
            }
        }
        
    }

    enum ErrorType: LocalizedError {
        case invalidUrl
        case errorThrown(Error)
        case noData
        case unknowed
        
        var errorDescription: String {
            switch self {
            case .invalidUrl:
                return "invalid Error"
            case .errorThrown(let error):
                return error.localizedDescription
            case .noData:
                return "no Data"
            case .unknowed:
                return "unknowned"
            }
        }
    }
    
}
