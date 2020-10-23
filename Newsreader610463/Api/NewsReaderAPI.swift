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
            .map({$0.data})
            .decode(type: Response.self, decoder: JSONDecoder())
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
                        completion(.failure(RequestError.decodingError(decodingError)))
                        print(RequestError.decodingError(decodingError))
                    default:
                        completion(.failure(RequestError.genericError(error)))
                        print(RequestError.genericError(error))
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
    
    
    func logout(){
        accessToken = nil
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
