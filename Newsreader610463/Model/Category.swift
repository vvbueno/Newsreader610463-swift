//
//  Category.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct Category: Decodable {
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
    
}
