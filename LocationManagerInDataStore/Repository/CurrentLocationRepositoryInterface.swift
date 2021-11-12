//
//  CurrentLocationRepositoryInterface.swift
//  LocationManagerInDataStore
//
//  Created by sasaki.ken on 2021/11/11.
//

import Foundation

protocol CurrentLocationRepositoryInterface {
    func getStatus() -> LocationStatusType
    func callRequestWhenInUse(complication: @escaping(LocationStatusType) -> Void)
    func callStartUpdateLocation()
    var delegate: CurrentLocationRepositoryDelegate? { get set }
}
