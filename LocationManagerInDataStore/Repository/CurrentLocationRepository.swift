//
//  CurrentLocationRepository.swift
//  LocationManagerInDataStore
//
//  Created by sasaki.ken on 2021/11/11.
//

import Foundation

protocol CurrentLocationRepositoryDelegate: AnyObject {
    func getCurrentLocation(lat: String, lng: String)
    func failUpdateLocation()
}

class CurrentLocationRepository: CurrentLocationRepositoryInterface {
    private let dataStore = CurrentLocationDataStore()
    weak var delegate: CurrentLocationRepositoryDelegate?
    
    func getStatus() -> LocationStatusType {
        let status = dataStore.statusType
        return status
    }
    
    func callRequestWhenInUse(complication: @escaping(LocationStatusType) -> Void) {
        dataStore.requestWhenInUse { status in
            complication(status)
        }
    }
    
    func callStartUpdateLocation() {
        dataStore.delegate = self
        dataStore.startUpdateLocation()
    }
}

extension CurrentLocationRepository: CurrentLocationDataStoreDelegate {
    func updatedLocation(lat: String, lng: String) {
        delegate?.getCurrentLocation(lat: lat, lng: lng)
    }
    
    func didFailUpdateLocation() {
        delegate?.failUpdateLocation()
    }
}
