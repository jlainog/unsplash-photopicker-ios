//
//  SearchPhotosRequest.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-09-27.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation
import unsplash_swift

class SearchPhotosRequestOperation: UnsplashPagedRequestOperation {
    let query: String

    init(with query: String, page: Int = 1, perPage: Int = 10) {
        self.query = query
        super.init(with: page, perPage: perPage)
    }

    init(with query: String, cursor: Unsplash.Cursor) {
        self.query = query
        super.init(with: cursor)
    }

    override func makeDataTask() -> URLSessionDataTask? {
        Unsplash.DataTaskFactory.searchPhotos(
            with: query,
            cursor: cursor
        ) {
            self.completionHandler($0.map({ $0.results }))
        }
    }
}
