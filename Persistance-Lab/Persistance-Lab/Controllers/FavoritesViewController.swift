//
//  FavoritesViewController.swift
//  Persistance-Lab
//
//  Created by casandra grullon on 1/18/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favorited = [PhotoJournal]() {
        didSet{
            DispatchQueue.main.async {
                self.loadFaves()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFaves()
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func loadFaves() {
        do {
            favorited = try PersistanceHelper.loadData().filter { $0.favedBy == "Casandra"}
        } catch {
            print("load data error")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first else {
            fatalError("could not segue")
        }
        detailVC.photo = favorited[indexPath.row]
    }
    
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorited.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as? FavoriteCell else {
            fatalError("could not type cast cell")
        }
        let photo = favorited[indexPath.row]
        cell.configureCell(for: photo)
        cell.delegate = self
        return cell
    }
    
}
extension FavoritesViewController: favoriteCellDelegate {
    func didLongPress(_ faveCell: FavoriteCell) {
        guard let indexPath = collectionView.indexPath(for: faveCell) else {
            return
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
            self?.deleteImage(indexPath: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    private func deleteImage(indexPath: IndexPath) {
        do {
            try PersistanceHelper.deletePhoto(photo: indexPath.row)
            favorited.remove(at: indexPath.row)
            collectionView.reloadItems(at: [indexPath])
        } catch {
            print("delete error \(error)")
        }
    }
}


extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 3
        let totalSpace: CGFloat = numberOfItems * itemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpace) / numberOfItems
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
