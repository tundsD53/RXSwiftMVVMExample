//
//  CharactersJSON.swift
//  RxSwiftAndMVVMTests
//
//  Created by Tunde on 22/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation

struct CharactersMock {
    
    private static let json = #"{"info":{"count":394,"pages":20,"next":"https://rickandmortyapi.com/api/character/?page=2","prev":""},"results":[{"id":1,"name":"Rick Sanchez","status":"Alive","species":"Human","type":"","gender":"Male","origin":{"name":"Earth","url":"https://rickandmortyapi.com/api/location/1"},"location":{"name":"Earth","url":"https://rickandmortyapi.com/api/location/20"},"image":"https://rickandmortyapi.com/api/character/avatar/1.jpeg","episode":["https://rickandmortyapi.com/api/episode/1","https://rickandmortyapi.com/api/episode/2"],"url":"https://rickandmortyapi.com/api/character/1","created":"2017-11-04T18:48:46.250Z"}]}"#
    
    static func getJSONDict() -> [String: Any] {
        let data = Data(json.utf8)
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return [:] }
        return json
    }
    
}
