//
//  UnsplashPhoto+DragAndDrop.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit
import unsplash_swift

extension Photo {
    var itemProvider: NSItemProvider {
        return NSItemProvider(object: UnsplashPhotoItemProvider(with: self))
    }

    var dragItem: UIDragItem {
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = self
        dragItem.previewProvider = {
            let photoView: PhotoView = .build(with: self)

            photoView.userNameLabel.isHidden = true
            photoView.layer.cornerRadius = 12
            photoView.frame.size.width = 300
            photoView.frame.size.height = 300 * CGFloat(self.height) / CGFloat(self.width)
            photoView.layoutSubviews()

            let parameters = UIDragPreviewParameters()
            parameters.backgroundColor = .clear

            return UIDragPreview(view: photoView, parameters: parameters)
        }
        return dragItem
    }
}
