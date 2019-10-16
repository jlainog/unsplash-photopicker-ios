//
//  UnsplashPhotoPickerViewController+UICollectionView.swift
//  UnsplashPhotoPicker
//
//  Created by Bichon, Nicolas on 2018-10-15.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension UnsplashPhotoPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            assertionFailure("Cell must be registered")
            return .init()
        }

        if let photo = dataSource.item(at: indexPath.item) {
            cell.configure(with: photo)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingView.reuseIdentifier, for: indexPath)
        guard let pagingView = view as? PagingView else { return view }

        pagingView.isLoading = dataSource.isFetching
        return pagingView
    }
}

// MARK: - UICollectionViewDelegate
extension UnsplashPhotoPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let prefetchRatio: Double = 2 / 3
        let perPageCount = Double(dataSource.cursor.perPage)
        let prefetchCount = Int(perPageCount * prefetchRatio)
        let prefetchItemStartIndex = dataSource.items.count - prefetchCount
        if indexPath.item == prefetchItemStartIndex {
            fetchNextItems()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = dataSource.item(at: indexPath.item), collectionView.hasActiveDrag == false else { return }

        if allowsMultipleSelection {
            updateTitle()
            updateDoneButtonState()
        } else {
            delegate?.unsplashPhotoPickerViewController(self, didSelectPhotos: [photo])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if allowsMultipleSelection {
            updateTitle()
            updateDoneButtonState()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UnsplashPhotoPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = dataSource.item(at: indexPath.item) else { return .zero }

        let width = collectionView.frame.width
        let height = CGFloat(photo.height) * width / CGFloat(photo.width)
        return CGSize(width: width, height: height)
    }
}

// MARK: - WaterfallLayoutDelegate
extension UnsplashPhotoPickerViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = dataSource.item(at: indexPath.item) else { return .zero }

        return CGSize(width: photo.width, height: photo.height)
    }
}
