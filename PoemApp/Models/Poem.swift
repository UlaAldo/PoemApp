//
//  Synonym.swift
//  PoemApp
//
//  Created by Юлия Алдохина on 12/05/22.
//

import Foundation

struct ResultSynonym: Decodable {
    let result: [Synonym]
}

struct Synonym: Decodable {
    let definition: String
    let synonyms: String
}

struct Rhymes: Decodable {
    let rhymes: String
}

