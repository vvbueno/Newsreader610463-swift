//
//  LoginRequest.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct LoginRequest: Encodable {
    
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "UserName"
        case password = "Password"
    }
}
