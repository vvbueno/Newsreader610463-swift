//
//  NewsReaderAPI.swift
//  Newsreader610463
//
//  Created by Vicente on 11/10/2020.
//

import Foundation
import Combine
import KeychainAccess
import SwiftUI

final class NewsReaderAPI: ObservableObject {
    
    static let shared = NewsReaderAPI()
    
    @ObservedObject var userSettings = UserSettings.shared
    
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
    
    func execute<Response:Decodable>(
        request: URLRequest,
        completion: @escaping (Result<Response, RequestError>) -> Void){
        
        var request = request
        
        if(isAuthenticated){
            request.setValue(self.accessToken, forHTTPHeaderField: "x-authtoken")
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { (data, response) in
                guard data.count > 0 else {
                    return Data("{}".utf8)
                }
                return data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .retry(1)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        print("URLError")
                        completion(.failure(RequestError.urlError(urlError)))
                    case let decodingError as DecodingError:
                        print("DecodingError")
                        completion(.failure(RequestError.decodingError(decodingError)))
                    default:
                        print("genericError")
                        completion(.failure(RequestError.genericError(error)))
                    }
                }
            }) { response in
                completion(.success(response))
            }
    }
    
    func login(username: String,
               password: String,
               completion: @escaping (Result<LoginResponse, RequestError>) -> Void){
        
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
        
        execute(request: urlRequest, completion: completion)
    }
    
    func register(username: String,
               password: String,
               completion: @escaping (Result<RegisterResponse, RequestError>) -> Void){
        
        let url = URL(string: Endpoints.Authentication.register)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let parameters = RegisterRequest(
            username: username,
            password: password
        )
        
        guard let body = try? JSONEncoder().encode(parameters) else {return}
        urlRequest.httpBody = body
        
        execute(request: urlRequest, completion: completion)
    }
    
    func logout(){
        accessToken = nil
        do {
            try keychain.remove(accessTokenKeyChainKey)
            userSettings.clearUsername()
        } catch let error {
            print("Error deleting accessTokenKeyChainKey: \(error)")
        }
    }
    
    func getArticlesList(completion: @escaping (Result<GetArticlesListResponse, RequestError>) -> Void){
        
        let url = URL(string: Endpoints.Articles.getArticles)!
        
        execute(request: URLRequest(url: url), completion: completion)
    }
    
    func getArticleDetails(of article: Article,
                    completion: @escaping (Result<GetArticlesDetailsResponse, RequestError>) -> Void){
        
        let endpointWithId = Endpoints.Articles.getArticle.replacingOccurrences(of: "{id}", with: String(article.id))
        let url = URL(string: endpointWithId)!
        
        
        execute(request: URLRequest(url: url), completion: completion)
    }
    
    func getLikedArticlesList(completion: @escaping (Result<GetArticlesListResponse, RequestError>) -> Void){
        
        let url = URL(string: Endpoints.Articles.getLikedArticles)!
        
        execute(request: URLRequest(url: url), completion: completion)
    }
    
    func likeArticle(of article: Article,
                    completion: @escaping (Result<LikeArticleResponse, RequestError>) -> Void){
        
        let endpointWithId = Endpoints.Articles.likeArticle.replacingOccurrences(of: "{id}", with: String(article.id))
        
        let url = URL(string: endpointWithId)!
        
        var urlRequest = URLRequest(url: url)
        
        if(!article.isLiked){
            urlRequest.httpMethod = "PUT"
        } else {
            urlRequest.httpMethod = "DELETE"
        }
        
        execute(request: urlRequest, completion: completion)
    }
    
    func getImage(for urlRequest: URLRequest, completion: @escaping (Result<UIImage, RequestError>) -> Void){
        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map({ UIImage(data: $0.data) ?? UIImage()})
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(RequestError.urlError(error))
                }
            }) { image in
                completion(.success(image))
            }
    }
    
}
