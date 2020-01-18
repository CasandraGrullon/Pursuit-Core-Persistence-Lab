//
//  FileManager.swift
//  Persistance-Lab
//
//  Created by casandra grullon on 1/18/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

extension FileManager {
    
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func pathToDocumentsDirectory(with filename: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
}
