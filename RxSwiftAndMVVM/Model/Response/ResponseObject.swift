//
//  ResponseObject.swift
//  RxSwiftAndMVVM
//
//  Created by Tunde on 22/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Moya

struct ResponseObject<T> {
    let response: Moya.Response?
    let data: T?
}
