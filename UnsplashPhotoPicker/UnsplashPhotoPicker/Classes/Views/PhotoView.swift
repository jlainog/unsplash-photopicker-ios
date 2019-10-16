//
//  PhotoView.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-06.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit
import unsplash_swift

class PhotoView: UIView {

    static func build() -> PhotoView {
        let nib = UINib(nibName: "PhotoView", bundle: Bundle(for: PhotoView.self))
        guard let photoView = nib.instantiate(withOwner: nil, options: nil).first as? PhotoView else {
            assertionFailure("Xib must Exist")
            return .init()
        }
        return photoView
    }

    static func build(with photo: Photo) -> PhotoView {
        let photoView: PhotoView = .build()
        photoView.configure(with: photo)
        return photoView
    }

    private var imageDownloader: ImageDownloader = .init()
    private var screenScale: CGFloat { return UIScreen.main.scale }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet var overlayViews: [UIView]!

    var showsUsername = true {
        didSet {
            userNameLabel.alpha = showsUsername ? 1 : 0
            gradientView.alpha = showsUsername ? 1 : 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        accessibilityIgnoresInvertColors = true
        gradientView.setColors([
            .init(color: .clear, location: 0),
            .init(color: UIColor(white: 0, alpha: 0.5), location: 1)
        ])
    }

    func prepareForReuse() {
        userNameLabel.text = nil
        imageView.backgroundColor = .clear
        imageView.image = nil
        imageDownloader.cancel()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let fontSize: CGFloat = traitCollection.horizontalSizeClass == .compact ? 10 : 13
        userNameLabel.font = UIFont.systemFont(ofSize: fontSize)
    }

    // MARK: - Setup

    func configure(with photo: Photo, showsUsername: Bool = true) {
        self.showsUsername = showsUsername
        userNameLabel.text = photo.user.displayName
        imageView.backgroundColor = photo.color
        downloadImage(with: photo)
    }

    private func downloadImage(with photo: Photo) {
        imageDownloader.load(
            photo,
            size: frame.size,
            kind: .regular
        ) { [weak self] (image, isCached) in
            guard let self = self,
                let image = image,
                self.imageDownloader.isCancelled == false
                else {
                    return
            }

            if isCached {
                self.imageView.image = image
            } else {
                UIView.transition(with: self,
                                  duration: 0.25,
                                  options: [.transitionCrossDissolve],
                                  animations: { self.imageView.image = image},
                                  completion: nil)
            }
        }
    }

}
