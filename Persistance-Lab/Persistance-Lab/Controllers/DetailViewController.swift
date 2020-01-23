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
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var previewURLLabel: UILabel!
    @IBOutlet weak var webformatURLLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var photo: PhotoJournal?
    
    var favorited = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        likesLabel.text = "Likes \(photo?.likes ?? 1)"
        favoritesLabel.text = "Favorited \(photo?.favorites ?? 1)"
        previewURLLabel.text = "preview: \(photo?.previewURL ?? "")"
        webformatURLLabel.text = photo?.webformatURL
        let tags = photo?.tags.components(separatedBy: ", ")
        let hashtags = tags?.joined(separator: " #")
        tagsLabel.text = "#\(hashtags ?? "")"
        
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
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        guard let faved = photo else {
            return
        }
        
        let fave = PhotoJournal(largeImageURL: faved.largeImageURL, webformatURL: faved.webformatURL, likes: faved.likes, favorites: faved.favorites, tags: faved.tags, previewURL: faved.previewURL, favedBy: "Casandra")
        
        let filledHeart = UIImage(systemName: "heart.fill")
        let emptyHeart = UIImage(systemName: "heart")
        
        favorited.toggle()
        
        if favorited == false {
            sender.setBackgroundImage(filledHeart, for: .normal)
            sender.tintColor = .red
        } else {
            sender.setBackgroundImage(emptyHeart, for: .normal)
        }
        
        do {
            try PersistanceHelper.create(photo: fave)
            
        } catch {
            print("cannot create fave \(error)")
        }
        
    }
    
}
