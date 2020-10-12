//
//  LoginResponse.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct LoginResponse: Decodable {
    
    let authToken: String
    
    enum CodingKeys: String, CodingKey {
        case authToken = "AuthToken"
    }
    
}
