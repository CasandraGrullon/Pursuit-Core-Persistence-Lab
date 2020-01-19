//
//  DetailViewController.swift
//  Persistance-Lab
//
//  Created by casandra grullon on 1/17/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import ImageKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var previewURLLabel: UILabel!
    @IBOutlet weak var webformatURLLabel: UILabel!
    
    var photo: PhotoJournal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        likesLabel.text = "Likes \(photo?.likes ?? 1)"
        favoritesLabel.text = "Favorited \(photo?.favorites ?? 1)"
        previewURLLabel.text = "preview: \(photo?.previewURL ?? "")"
        webformatURLLabel.text = photo?.webformatURL
        
        imageView.getImage(with: photo?.largeImageURL ?? "") { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(systemName: "photo.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
    
    @IBAction func addToFavorite(segue: UIStoryboardSegue) {
        guard let favoritesVC = segue.source as? FavoritesViewController, let favorite = favoritesVC.favorited.first else {
            fatalError("in unwind segue")
        }
        
        do {
            try PersistanceHelper.create(photo: favorite)
        } catch {
            print("could not create favorites")
        }
        
    }
}
