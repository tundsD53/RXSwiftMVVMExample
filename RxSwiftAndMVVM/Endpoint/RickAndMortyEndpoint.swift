//
//  RickAndMortyEndpoint.swift
//  RxSwiftAndMVVM
//
//  Created by Tunde on 20/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation
import Moya

enum RickAndMortyEndpoint {
    case characters(networkConfig: NetworkConfig, name: String?)
}

extension RickAndMortyEndpoint: TargetType {

    var baseURL: URL {
        
        switch self {
        case .characters(let item): return URL(string: item.networkConfig.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/character/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .characters:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task {
        switch self {
        case .characters(let item):
            guard let name = item.name,
                      !name.isEmpty else { return .requestPlain }
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        }
    }
}
