//
//  PhotoJournal.swift
//  Persistance-Lab
//
//  Created by casandra grullon on 1/17/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct PhotoJournalHits: Decodable {
    let hits: [PhotoJournal]
}
struct PhotoJournal: Decodable {
    let largeImageURL: String
    let webformatURL: String
    let likes: Int
    let favorites: Int
    let tags: String
}
