//
//  RxSwiftAndMVVMTests.swift
//  RxSwiftAndMVVMTests
//
//  Created by Tunde on 22/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Moya
import XCTest
import OHHTTPStubs
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import UIKit

@testable import RxSwiftAndMVVM

class RxSwiftAndMVVMTests: XCTestCase {

    var disposeBag: DisposeBag!

    var host: String!
    var path: String!
    var baseUrl: String!
    var absoluteUrl: String!
    
    var characterViewModel: CharactersViewModel!
    var provider: MoyaProvider<RickAndMortyEndpoint>!
    
    var charactersJSON: [String: Any]!
    
    override func setUp() {
        
        disposeBag = DisposeBag()

        host = "localhost:8000"
        baseUrl = "https://\(host ?? "")/api"
        path = "/character/"
        absoluteUrl = "\(baseUrl ?? "")\(path ?? "")"
        
        provider = MoyaProvider<RickAndMortyEndpoint>(plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)])
        characterViewModel = CharactersViewModel(networkConfig: NetworkConfig(baseUrl: baseUrl), provider: MoyaProvider<RickAndMortyEndpoint>(plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)]))
        
        charactersJSON = CharactersMock.getJSONDict()
    }

    override func tearDown() {
        
        host = nil
        path = nil
        baseUrl = nil
        absoluteUrl = nil
        
        characterViewModel = nil
        provider = nil
        
        disposeBag = nil
        
        charactersJSON = nil
        
        OHHTTPStubs.removeAllStubs()
    }
    
    func test_200_Request_Success() {

        stub(condition: isMethodGET() && isAbsoluteURLString(absoluteUrl)) { _ in
            return OHHTTPStubsResponse(
                jsonObject: self.charactersJSON,
                statusCode: 200,
                headers: .none
            )
        }

        let expectation = self.expectation(description: "Subscribes to an observable that makes a call to the service")

        characterViewModel
            .getCharactersObservable()
            .subscribe(onNext: { result in

                switch result {

                case .success(let response):
                    expectation.fulfill()
                    XCTAssertNotNil(response.response, "The response that we get back shouldn't be nil")
                    XCTAssertEqual(response.response?.statusCode, 200)
                default: break
                }
            }).disposed(by: disposeBag)

        self.characterViewModel.findCharacters(with: "")

        self.waitForExpectations(timeout: 0.5, handler: .none)
    }
    
    func test_400_Request_Success() {
        
        stub(condition: isMethodGET() && isAbsoluteURLString(absoluteUrl)) { _ in
            return OHHTTPStubsResponse(
                jsonObject: self.charactersJSON,
                statusCode: 400,
                headers: .none
            )
        }
        
        let expectation = self.expectation(description: "Subscribes to an observable that makes a call to the service")
        
        characterViewModel
            .getCharactersObservable()
            .subscribe(onNext: { result in
                
                switch result {
                    
                case .failure(let error):
                    if let error = error as? MoyaError {
                        expectation.fulfill()
                        XCTAssertNotNil(error.response, "The response shouldn't be nil")
                        XCTAssertEqual(error.response?.statusCode, 400)
                    }
                default: break
                }
                
            }).disposed(by: disposeBag)
        
        self.characterViewModel.findCharacters(with: "")
        
        self.waitForExpectations(timeout: 0.5, handler: .none)
    }
    
    
    func testMethodType() {
        
        stub(condition: isMethodGET() && isAbsoluteURLString(absoluteUrl)) { _ in
            return OHHTTPStubsResponse(
                jsonObject: self.charactersJSON,
                statusCode: 200,
                headers: .none
            )
        }
        
        let expectation = self.expectation(description: "Subscribes to an observable that makes a call to the service")
        
        characterViewModel
            .getCharactersObservable()
            .subscribe(onNext: { result in
                
                switch result {
                    
                case .success(let response):
                    expectation.fulfill()
                    XCTAssertNotNil(response.response, "The response that we get back shouldn't be nil")
                    XCTAssertEqual(response.response?.request?.httpMethod, "GET")
                default: break
                }
            }).disposed(by: disposeBag)
        
        self.characterViewModel.findCharacters(with: "")
        
        self.waitForExpectations(timeout: 0.5, handler: .none)
    }
    
    func testRequestString() {
        
        stub(condition: isMethodGET() && isAbsoluteURLString(absoluteUrl)) { _ in
            return OHHTTPStubsResponse(
                jsonObject: self.charactersJSON,
                statusCode: 200,
                headers: .none
            )
        }
        
        let expectation = self.expectation(description: "Subscribes to an observable that makes a call to the service")
        
        characterViewModel
            .getCharactersObservable()
            .subscribe(onNext: { result in
                
                switch result {
                    
                case .success(let response):
                    expectation.fulfill()
                    XCTAssertNotNil(response.response, "The response that we get back shouldn't be nil")
                    XCTAssertEqual(response.response?.request?.url?.absoluteString, self.absoluteUrl)
                default: break
                }
            }).disposed(by: disposeBag)
        
        self.characterViewModel.findCharacters(with: "")
        
        self.waitForExpectations(timeout: 0.5, handler: .none)
    }
    
    func testResponseBody() {
        
        stub(condition: isMethodGET() && isAbsoluteURLString(absoluteUrl)) { _ in
            return OHHTTPStubsResponse(
                jsonObject: self.charactersJSON,
                statusCode: 200,
                headers: .none
            )
        }
        
        let expectation = self.expectation(description: "Subscribes to an observable that makes a call to the service")
        
        characterViewModel
            .getCharactersObservable()
            .subscribe(onNext: { result in
                
                switch result {
                    
                case .success(let response):
                    expectation.fulfill()
                    XCTAssertNotNil(response.data, "The mapped object shouldn't be nil")
                    XCTAssertEqual(response.data?.count, 1)
                    XCTAssertNotNil(response.data?.first, "The mapped object shouldn't be nil")
                    
                    XCTAssertNotNil(response.data?.first?.id, "This ID shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.id, 1)
                    
                    XCTAssertNotNil(response.data?.first?.name, "This name shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.name, "Rick Sanchez")
                    
                    XCTAssertNotNil(response.data?.first?.status, "This status shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.status, CharacterStatus.alive)
                    
                    XCTAssertNotNil(response.data?.first?.type, "This type shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.type, "")
                    
                    XCTAssertNotNil(response.data?.first?.gender, "This gender shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.gender, CharacterGender.male)
                    
                    XCTAssertNotNil(response.data?.first?.origin, "This origin shouldn't be nil")
                    XCTAssertNotNil(response.data?.first?.origin?.name, "This origin name shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.origin?.name, "Earth")
                    XCTAssertNotNil(response.data?.first?.origin?.url, "This origin url shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.origin?.url, "https://rickandmortyapi.com/api/location/1")
                    
                    XCTAssertNotNil(response.data?.first?.location, "This location shouldn't be nil")
                    XCTAssertNotNil(response.data?.first?.location?.name, "This location name shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.location?.name, "Earth")
                    XCTAssertNotNil(response.data?.first?.location?.url, "This location url shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.location?.url, "https://rickandmortyapi.com/api/location/20")
                    
                    XCTAssertNotNil(response.data?.first?.image, "This image shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.image, "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
                    
                    XCTAssertNotNil(response.data?.first?.episode, "This episode shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.episode?.count, 2)
                    XCTAssertNotNil(response.data?.first?.episode?[0], "This first episode shouldn't be nil")
                    XCTAssertNotNil(response.data?.first?.episode?[1], "This second episode shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.episode?[0], "https://rickandmortyapi.com/api/episode/1")
                    XCTAssertEqual(response.data?.first?.episode?[1], "https://rickandmortyapi.com/api/episode/2")
                    
                    XCTAssertNotNil(response.data?.first?.url, "This url shouldn't be nil")
                    XCTAssertEqual(response.data?.first?.url, "https://rickandmortyapi.com/api/character/1")

                    XCTAssertNotNil(response.data?.first?.created, "This date shouldn't be nil")
                    XCTAssertEqual(Date(timeIntervalSince1970: 1509821326.25), response.data?.first?.created)
                    
                default: break
                }
            }).disposed(by: disposeBag)
        
        self.characterViewModel.findCharacters(with: "")
        
        self.waitForExpectations(timeout: 0.5, handler: .none)
    }
}
