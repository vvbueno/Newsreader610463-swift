//
//  GetFeedsResponse.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

struct GetFeedsResponse: Decodable {
    
    let feeds: [Feed]
    
    enum CodingKeys: String, CodingKey {
        case feeds = "Results"
    }
    
}
