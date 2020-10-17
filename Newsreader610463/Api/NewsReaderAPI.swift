//
//  NewsReaderAPI.swift
//  Newsreader610463
//
//  Created by Vicente on 11/10/2020.
//

import Foundation
import Combine
import KeychainAccess

struct Endpoints {
    
    static let apiUrl = "https://inhollandbackend.azurewebsites.net/api"
    
    struct Authentication {
        static let login = apiUrl + "/Users/login"
        static let register = apiUrl + "/Users/register"
    }
    
    struct Articles {
        static let getArticles = apiUrl + "/Articles"
        static let getArticle = apiUrl + "/Articles/{id}"
        static let getLikedArticles = apiUrl + "/Articles/liked"
        static let likeArticle = apiUrl + "/Articles/{id}/like"
    }
    
    struct Feeds {
        static let getFeeds = apiUrl + "/Feeds"
    }
}

final class NewsReaderAPI: ObservableObject {
    
    static let shared = NewsReaderAPI()
    
    //private var apiUrl = "https://inhollandbackend.azurewebsites.net/api"
    
    @Published var isAuthenticated: Bool = false
    
    private let keychain = Keychain()
    private var accessTokenKeyChainKey = "accessToken"
    
    private var cancellable: AnyCancellable?
    
    
    var accessToken: String? {
        get{
            try? keychain.get(accessTokenKeyChainKey)
        }
        set(newValue){
            guard let accessToken = newValue else {
                try? keychain.remove(accessTokenKeyChainKey)
                isAuthenticated = false
                return
            }
            try? keychain.set(accessToken, key: accessTokenKeyChainKey)
            isAuthenticated = true
        }
    }
    
    private init(){
        isAuthenticated = accessToken != nil
    }
    
    func login(username: String, password: String){
        
        let url = URL(string: Endpoints.Authentication.login)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let parameters = LoginRequest(
            username: username,
            password: password
        )
        
        guard let body = try? JSONEncoder().encode(parameters) else {return}
        urlRequest.httpBody = body
    }
    
    
    func logout(){
        accessToken = nil
    }
    
    func getArticlesList(completion: @escaping (Result<[Article], RequestError>) -> Void){
        
        let url = URL(string: Endpoints.Articles.getArticles)!
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: GetArticlesListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        completion(.failure(RequestError.urlError(urlError)))
                        print(RequestError.urlError(urlError))
                    case let decodingError as DecodingError:
                        print(RequestError.decodingError(decodingError))
                    default:
                        print(RequestError.genericError(error))
                    }
                }
            }) { response in
                completion(.success(response.articles))
            }
    }
    
    func getArticleDetails(of article: Article,
                    completion: @escaping (Result<ArticleDetails?, RequestError>) -> Void){
        
        let endpointWithId = Endpoints.Articles.getArticle.replacingOccurrences(of: "{id}", with: String(article.id))
        
        let url = URL(string: endpointWithId)!
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: GetArticlesDetailsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        completion(.failure(RequestError.urlError(urlError)))
                        print(RequestError.urlError(urlError))
                    case let decodingError as DecodingError:
                        print(RequestError.decodingError(decodingError))
                    default:
                        print(RequestError.genericError(error))
                    }
                }
            }) { response in
                print(response.articles.first!)
                completion(.success(response.articles.first))
            }
    }
}
