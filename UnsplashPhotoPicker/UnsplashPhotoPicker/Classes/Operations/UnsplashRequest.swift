//
//  UnsplashRequest.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

class UnsplashRequestOperation<T, E: Error>: NetworkRequestOperation {
    var value: T?

    var completionHandler: (Result<T, E>) -> Void {
        return { [weak self] result in
            self?.complete(with: result)
        }
    }

    final func complete(with result: Result<T, E>) {
        switch result {
        case .success(let value):
            self.value = value
            completeOperation()
        case .failure(let error):
            complete(with: error)
        }
    }
}
