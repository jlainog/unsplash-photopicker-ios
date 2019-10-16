//
//  NetworkRequest.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation

class NetworkRequestOperation: ConcurrentOperation {
    private var task: URLSessionDataTask?

    override func main() {
        task = makeDataTask()
        task?.resume()
    }

    override func cancel() {
        task?.cancel()
        super.cancel()
    }

    func makeDataTask() -> URLSessionDataTask? {
        assertionFailure("Template Method")
        return nil
    }

}
