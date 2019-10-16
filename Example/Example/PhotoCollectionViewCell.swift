//
//  PhotoCollectionViewCell.swift
//  Example
//
//  Created by Bichon, Nicolas on 2018-10-25.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit
import unsplash_swift
import UnsplashPhotoPicker

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!

    private var imageDownloader: ImageDownloader = .init()

    func downloadPhoto(_ photo: Photo) {
        imageDownloader.load(photo) { [weak self] image, isCached in
            guard let self = self,
                let image = image else {
                    return
            }
            
            UIView.transition(with: self.photoImageView,
                              duration: 0.25,
                              options: [.transitionCrossDissolve],
                              animations: { self.photoImageView.image = image},
                              completion: nil)
        }
    }

}
