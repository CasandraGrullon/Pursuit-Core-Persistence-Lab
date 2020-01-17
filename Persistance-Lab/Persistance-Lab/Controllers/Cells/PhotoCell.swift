//
//  PhotoCell.swift
//  Persistance-Lab
//
//  Created by casandra grullon on 1/17/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import ImageKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    
    func configureCell(for photo: PhotoJournal) {
        photoImage.getImage(with: photo.largeImageURL) { [weak self] (result) in
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
