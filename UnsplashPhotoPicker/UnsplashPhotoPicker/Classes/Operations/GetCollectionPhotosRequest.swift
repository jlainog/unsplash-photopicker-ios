//
//  GetCollectionPhotos.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-09-28.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation
import unsplash_swift

class GetCollectionPhotosRequestOperation: UnsplashPagedRequestOperation {
    let collectionId: String

    init(with collectionId: String, page: Int = 1, perPage: Int = 10) {
        self.collectionId = collectionId
        super.init(with: page, perPage: perPage)
    }

    init(with collectionId: String, cursor: Unsplash.Cursor) {
        self.collectionId = collectionId
        super.init(with: cursor)
    }

    override func makeDataTask() -> URLSessionDataTask? {
        Unsplash.DataTaskFactory.collection(with: collectionId,
                                            cursor: cursor,
                                            handler: completionHandler)
    }
}
