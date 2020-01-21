//
//  FavoriteCell.swift
//  Persistance-Lab
//
//  Created by casandra grullon on 1/18/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

protocol favoriteCellDelegate: AnyObject {
    func didLongPress(_ faveCell: FavoriteCell)
}

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    weak var delegate: favoriteCellDelegate?
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressAction(gesture:)) )
        return gesture
    } ()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        delegate?.didLongPress(self)
    }
    
    func configureCell(for fave: PhotoJournal) {
        photoImage.getImage(with: fave.largeImageURL) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.photoImage.image = UIImage(systemName: "photo.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.photoImage.image = image
                }
            }
        }
    }
}
