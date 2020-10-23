//
//  ArticleDetails.swift
//  Newsreader610463
//
//  Created by Vicente on 17/10/2020.
//

import Foundation

struct ArticleDetails: Decodable, Identifiable {
    
    let id: Int
    let feedId: Int?
    let title: String
    let summary: String?
    let publishDate: String
    let image: URL?
    let url: URL
    let related: [String]?
    let categories: [Category]?
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case feedId = "Feed"
        case title = "Title"
        case summary = "Summary"
        case publishDate = "PublishDate"
        case image = "Image"
        case url = "Url"
        case related = "Related"
        case categories = "Categories"
        case isLiked = "IsLiked"
    }
    
    static let testData = ArticleDetails(id: 134068,
        feedId: 3,
        title: "Brighton predikt voorzichtigheid: 'Met valse start maken we levens kapot'",
        summary: "Brighton &amp; Hove Albion-voorzitter Paul Barber predikt voorzichtigheid bij een eventuele hervatting van de Premier League. De competitieorganisator willen over een maand het seizoen afmaken ondanks de coronacrisis.",
        publishDate: "2020-05-10T14:16:32",
        image: URL(string: "https://media.nu.nl/m/bd6xpyzaw32r_sqr256.jpg/brighton-predikt-voorzichtigheid-met-valse-start-maken-we-levens-kapot.jpg")!,
        url: URL(string: "https://www.nu.nl/voetbal/6050332/brighton-predikt-voorzichtigheid-met-valse-start-maken-we-levens-kapot.html")!,
        related: ["https://nu.nl/voetbal/6048760/brighton-voelt-niets-voor-spelen-op-neutraal-terrein-in-premier-league.html","https://nu.nl/voetbal/6048721/lampard-twijfelt-over-hervatten-premier-league-voetbal-moet-plek-kennen.html"],
        categories: Category.testData,
        isLiked: false)

}
