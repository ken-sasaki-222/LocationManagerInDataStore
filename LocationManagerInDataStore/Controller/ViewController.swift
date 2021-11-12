//
//  ViewController.swift
//  LocationManagerInDataStore
//
//  Created by sasaki.ken on 2021/11/11.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    private var currentLocationRepository: CurrentLocationRepositoryInterface
    
    init(currentLocationRepository: CurrentLocationRepositoryInterface) {
        self.currentLocationRepository = currentLocationRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.currentLocationRepository = CurrentLocationRepository()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func notDeterminedAction() {
        currentLocationRepository.delegate = self
        currentLocationRepository.callRequestWhenInUse { status in
            self.tapGpsButtonAction(status: status)
        }
    }

    private func allowAuthorizationStatusAction() {
        currentLocationRepository.delegate = self
        currentLocationRepository.callStartUpdateLocation()
    }
    
    private func notAllowAuthorizationStatusAction() {
        showSettingPageAlert()
    }
    
    private func tapGpsButtonAction(status: LocationStatusType) {
        switch status {
        case .notDetermined:
            notDeterminedAction()
        case .restricted:
            notAllowAuthorizationStatusAction()
        case .denied:
            notAllowAuthorizationStatusAction()
        case .authorizedAlways:
            allowAuthorizationStatusAction()
        case .authorizedWhenInUse:
            allowAuthorizationStatusAction()
        case .authorized:
            allowAuthorizationStatusAction()
        case .unknown:
            return
        }
    }
    
    private func showSettingPageAlert() {
        let alert = UIAlertController(
            title: "確認",
            message: "'設定'で位置情報サービスを許可してください。",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "設定へ",
            style: .default,
            handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        ))
        
        alert.addAction(UIAlertAction(
            title: "いいえ",
            style: .cancel,
            handler: nil)
        )
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showFailAlert() {
        let alert = UIAlertController(
            title: "エラー",
            message: "位置情報の取得に失敗しました。 \n 通信環境の良い場所でやり直してください。",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "はい",
            style: .default,
            handler: nil)
        )
        present(alert, animated: true, completion: nil)
    }

    @IBAction func tapGpsButton(_ sender: UIButton) {
        let status = currentLocationRepository.getStatus()
        tapGpsButtonAction(status: status)
    }
    
}

extension ViewController: CurrentLocationRepositoryDelegate {
    func getCurrentLocation(lat: String, lng: String) {
        latLabel.text = "緯度: \(lat)"
        lngLabel.text = "経度: \(lng)"
    }
    
    func failUpdateLocation() {
        showFailAlert()
    }
}

