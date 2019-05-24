//
//  PrimitiveSequence+BaseObservable.swift
//  RxSwiftAndMVVM
//
//  Created by Tunde on 23/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import RxSwift

extension PrimitiveSequence {
    func baseObservable() -> Observable<Element> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background)).observeOn(MainScheduler.instance).asObservable()
    }
}

