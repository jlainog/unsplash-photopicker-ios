//
//  UnsplashPhotoPicker.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-09.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit
import unsplash_swift

/// A protocol describing an object that can be notified of events from UnsplashPhotoPicker.
public protocol UnsplashPhotoPickerDelegate: class {

    /**
     Notifies the delegate that UnsplashPhotoPicker has selected photos.

     - parameter photoPicker: The `UnsplashPhotoPicker` instance responsible for selecting the photos.
     - parameter photos:      The selected photos.
     */
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [Photo])

    /**
     Notifies the delegate that UnsplashPhotoPicker has been canceled.

     - parameter photoPicker: The `UnsplashPhotoPicker` instance responsible for selecting the photos.
     */
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker)
}

/// `UnsplashPhotoPicker` is an object that can be used to select photos from Unsplash.
public final class UnsplashPhotoPicker: UINavigationController {
    private let photoPickerViewController: UnsplashPhotoPickerViewController

    /// A delegate that is notified of significant events.
    public weak var photoPickerDelegate: UnsplashPhotoPickerDelegate?

    /// Initializes an `UnsplashPhotoPicker` object with a configuration.
    /// - Parameters:
    ///   - accessKey: Your application’s access key.
    ///   - secretKey: Your application’s secret key.
    ///   - allowsMultipleSelection: Controls whether the picker allows multiple or single selection.
    public init(accessKey: String, secretKey: String, allowsMultipleSelection: Bool) {
        Unsplash.configure(accessKey: accessKey, secret: secretKey)

        self.photoPickerViewController = UnsplashPhotoPickerViewController(allowsMultipleSelection: allowsMultipleSelection)

        super.init(nibName: nil, bundle: nil)

        photoPickerViewController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        viewControllers = [photoPickerViewController]
    }

}

// MARK: - UnsplashPhotoPickerViewControllerDelegate
extension UnsplashPhotoPicker: UnsplashPhotoPickerViewControllerDelegate {
    func unsplashPhotoPickerViewController(_ viewController: UnsplashPhotoPickerViewController,
                                           didSelectPhotos photos: [Photo]) {
        photos.forEach(Unsplash.trackDownload)
        photoPickerDelegate?.unsplashPhotoPicker(self, didSelectPhotos: photos)
        dismiss(animated: true, completion: nil)
    }

    func unsplashPhotoPickerViewControllerDidCancel(_ viewController: UnsplashPhotoPickerViewController) {
        photoPickerDelegate?.unsplashPhotoPickerDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
}
