//
//  CharacterResponseResult.swift
//  RxSwiftAndMVVM
//
//  Created by Tunde on 20/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation

struct CharacterResponseResult: Codable {
    let info: CharacterInfo?
    let characters: Array<Character>?
    
    enum CodingKeys: String, CodingKey {
        case info
        case characters = "results"
    }
}
