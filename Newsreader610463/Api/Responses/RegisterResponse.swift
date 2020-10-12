//
//  RegisterResponse.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct RegisterResponse: Decodable {
    
    let success: Bool
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case message = "Message"
    }
    
}
