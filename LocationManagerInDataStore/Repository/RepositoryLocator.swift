//
//  RepositoryLocator.swift
//  LocationManagerInDataStore
//
//  Created by sasaki.ken on 2021/11/12.
//

import Foundation

class RepositoryLocator {
    
    static func getCurrentLocationRepository() -> CurrentLocationRepositoryInterface {
        return CurrentLocationRepository()
    }
}
