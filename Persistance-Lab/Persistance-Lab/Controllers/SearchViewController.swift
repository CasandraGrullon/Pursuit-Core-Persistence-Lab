//
//  ViewController.swift
//  Persistance-Lab
//
//  Created by casandra grullon on 1/16/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [PhotoJournal]() {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var searchQuery = "" {
        didSet {
            getPhotos(for: searchQuery)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos(for: "dogs")
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func getPhotos(for search: String) {
        PhotoJournalAPIClient.getPhotoJournals(for: search) { [weak self] (result) in
            switch result {
            case .failure(let appError) :
                print(appError)
            case .success(let journals):
                DispatchQueue.main.async {
                    self?.photos = journals
                }
            }
        }
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else {
            fatalError("could not type cast cell")
        }
        let photo = photos[indexPath.row]
        cell.configureCell(for: photo)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 0.25
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 4
        let totalSpace: CGFloat = numberOfItems * itemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpace) / numberOfItems
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
