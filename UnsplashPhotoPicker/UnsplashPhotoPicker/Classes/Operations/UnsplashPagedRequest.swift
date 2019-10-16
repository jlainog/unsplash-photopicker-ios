//
//  UnsplashPagedRequest.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-09-28.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation
import unsplash_swift

class UnsplashPagedRequestOperation: UnsplashRequestOperation<[Photo], Unsplash.RequestError> {

    let cursor: Unsplash.Cursor
    var items: [Photo] { value ?? [] }

    init(with cursor: Unsplash.Cursor) {
        self.cursor = cursor
        super.init()
    }

    init(with page: Int = 1, perPage: Int = 10) {
        self.cursor = .init(page: page, perPage: perPage)
        super.init()
    }

    func nextCursor() -> Unsplash.Cursor {
        return cursor.next()
    }

}
