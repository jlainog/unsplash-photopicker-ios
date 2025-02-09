//
//  UnsplashPhotoItemProvider.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-24.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit
import unsplash_swift

let kUTTypeUnsplashPhoto = "com.unsplash.photo"

final class UnsplashPhotoItemProvider: NSObject, Codable {

    let photo: Photo

    init(with photo: Photo) {
        self.photo = photo
        super.init()
    }

}

// MARK: - NSItemProviderWriting
extension UnsplashPhotoItemProvider: NSItemProviderWriting {
    enum ItemProviderError: Error {
        case cannotDecodeLink(key: String, photoIdentifier: String)
        case invalidTypeIdentifier(typeIdentifier: String)

        var localizedDescription: String {
            switch self {
            case .cannotDecodeLink(let key, let photoIdentifier):
                return "Cannot decode the \(key) link for photo ID \(photoIdentifier)."
            case .invalidTypeIdentifier(let typeIdentifier):
                return "Invalid type identifier \(typeIdentifier)."
            }
        }
    }

    static var writableTypeIdentifiersForItemProvider: [String] = [
        kUTTypeUnsplashPhoto,
        kUTTypeJPEG as String
    ]

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        switch typeIdentifier as CFString {
        case kUTTypeUnsplashPhoto as String:
            do {
                let data = try JSONEncoder().encode(self)
                completionHandler(data, nil)
            } catch {
                completionHandler(nil, error)
            }

        case kUTTypeJPEG:
            guard let url = photo.urls[.full] else {
                completionHandler(nil, ItemProviderError.cannotDecodeLink(key: Photo.LinkKind.download.rawValue, photoIdentifier: photo.identifier))
                return nil
            }

            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
                if error == nil {
                    Unsplash.trackDownload(self.photo)
                }

                completionHandler(data, error)
            })
            dataTask.resume()

            return dataTask.progress

        default:
            completionHandler(nil, ItemProviderError.invalidTypeIdentifier(typeIdentifier: typeIdentifier))
        }

        return nil
    }
}

// MARK: - NSItemProviderReading
extension UnsplashPhotoItemProvider: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [kUTTypeUnsplashPhoto]
    }

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> UnsplashPhotoItemProvider {
        return try JSONDecoder().decode(UnsplashPhotoItemProvider.self, from: data)
    }
}
