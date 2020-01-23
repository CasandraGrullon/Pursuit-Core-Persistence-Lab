//
//  PhotoJournalAPIClient.swift
//  Persistance-Lab
//
//  Created by casandra grullon on 1/17/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import NetworkHelper

struct PhotoJournalAPIClient {
    static func getPhotoJournals(for search: String, completion: @escaping (Result<[PhotoJournal], AppError>) -> () ) {
        
        let searchQuery = search.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let endpointURL = "https://pixabay.com/api/?key=\(Secrets.apiKey)&q=\(searchQuery ?? "dogs")"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(PhotoJournalHits.self, from: data)
                    completion(.success(results.hits))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        } 
    }
}
