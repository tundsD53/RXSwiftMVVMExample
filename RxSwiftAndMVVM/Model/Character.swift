//
//  Character.swift
//  RxSwiftAndMVVM
//
//  Created by Tunde on 20/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation

struct Character: Codable {
    let id: Int?
    let name: String?
    let status: CharacterStatus?
    let species: String?
    let type: String?
    let gender: CharacterGender?
    let origin: CharacterOrigin?
    let location: CharacterOrigin?
    let image: String?
    let episode: Array<String>?
    let url: String?
    let created: Date?
}

