//
//  CurrentLocationDataStore.swift
//  LocationManagerInDataStore
//
//  Created by sasaki.ken on 2021/11/11.
//

import Foundation
import CoreLocation

protocol CurrentLocationDataStoreDelegate: AnyObject {
    func updatedLocation(lat: String, lng: String)
    func didFailUpdateLocation()
}

class CurrentLocationDataStore: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private var requestCallback: ((LocationStatusType) -> Void)?
    weak var delegate: CurrentLocationDataStoreDelegate?
    var statusType: LocationStatusType
    
    override init() {
        self.locationManager = CLLocationManager()
        self.statusType = .unknown
        super.init()
        locationManager.delegate = self
    }
    
    func requestWhenInUse(complication: @escaping(LocationStatusType) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        requestCallback = complication
    }
    
    func startUpdateLocation() {
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            statusType = .notDetermined
        case .restricted:
            statusType = .restricted
        case .denied:
            statusType = .denied
        case .authorizedAlways:
            statusType = .authorizedAlways
        case .authorizedWhenInUse:
            statusType = .authorizedWhenInUse
        case .authorized:
            statusType = .authorized
        @unknown default:
            return
        }
        requestCallback?(statusType)
        requestCallback = nil // 複数回呼ばれたくないのでnilに
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        print("緯度:", currentLocation.latitude, "経度:", currentLocation.longitude)
        
        let lat = String(currentLocation.latitude)
        let lng = String(currentLocation.longitude)
        delegate?.updatedLocation(lat: lat, lng: lng)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager did fail with error:", error)
        print("LocationManager localize error:", error.localizedDescription)
        delegate?.didFailUpdateLocation()
        locationManager.stopUpdatingLocation()
    }
}
