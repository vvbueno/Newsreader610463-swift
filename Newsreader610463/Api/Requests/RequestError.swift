//
//  RequestError.swift
//  Newsreader610463
//
//  Created by Vicente on 12/10/2020.
//

import Foundation

enum RequestError: Error {
    case urlError(URLError)
    case decodingError(DecodingError)
    case genericError(Error)
}
