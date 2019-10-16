//
//  PhotosDataSourceFactory.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-10-10.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit
import unsplash_swift

enum PhotosDataSourceFactory: PagedDataSourceFactory {
    case search(query: String)
    case collection(identifier: String)

    var dataSource: PagedDataSource {
        return PagedDataSource(with: self)
    }

    func initialCursor() -> Unsplash.Cursor {
        .init(page: 1, perPage: 30)
    }

    func request(with cursor: Unsplash.Cursor) -> UnsplashPagedRequestOperation {
        switch self {
        case .search(let query):
            return SearchPhotosRequestOperation(with: query, cursor: cursor)
        case .collection(let identifier):
            return GetCollectionPhotosRequestOperation(with: identifier, cursor: cursor)
        }
    }
}
