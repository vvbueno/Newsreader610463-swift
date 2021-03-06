//
//  Category.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct Category: Decodable, Identifiable {
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
    
    static let testData = [ Category(id:4270,name: "Sport"), Category(id:4277,name: "Voetbal") ]
    
}
