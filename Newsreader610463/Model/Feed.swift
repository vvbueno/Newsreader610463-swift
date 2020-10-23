//
//  Feed.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct Feed: Decodable, Identifiable {

    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
    
    static let testData = [ Feed(id: 1, name: "Algemeen"), Feed(id: 2, name: "Internet"), Feed(id: 3, name: "Sport"), Feed(id: 4, name: "Opmerkelijk") ]
    
}
