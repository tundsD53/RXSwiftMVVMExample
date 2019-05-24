//
//  CharactersViewModel.swift
//  RxSwiftAndMVVM
//
//  Created by Tunde on 21/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Moya
import RxSwift

class CharactersViewModel {

    typealias CharacterResponse = ResponseObject<Array<Character>>
    typealias CharacterResult = Result<CharacterResponse, Error>
    
    private let provider: MoyaProvider<RickAndMortyEndpoint>!
    private let disposeBag = DisposeBag()
    
    private var characters = PublishSubject<CharacterResult>()
    
    private var networkConfig: NetworkConfig!
    
    init(networkConfig: NetworkConfig, provider: MoyaProvider<RickAndMortyEndpoint>) {
        self.networkConfig = networkConfig
        self.provider = provider
    }

    func getCharactersObservable() -> Observable<CharacterResult> {
        return self.characters.asObservable()
    }
}

extension CharactersViewModel {
    
    func findCharacters(with name: String?){
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self.provider
            .rx
            .request(.characters(networkConfig: networkConfig, name: name))
            .baseObservable()
            .filterSuccessfulStatusCodes()
            .subscribe(onNext: { [unowned self] response in
                let responseObject = ResponseObject(response: response, data: try? response.map(Array<Character>.self, atKeyPath: "results", using: decoder, failsOnEmptyData: false))
                self.characters.onNext(.success(responseObject))
            }, onError: { [unowned self] error in
                self.characters.onNext(.failure(error))
            }).disposed(by: disposeBag)
    }
}
