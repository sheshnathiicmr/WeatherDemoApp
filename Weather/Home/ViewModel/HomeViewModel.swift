//
//  HomeViewModel.swift
//  Weather
//
//  Created by sheshnath kumar on 10/6/21.
//

import Foundation
import CoreLocation

//MARK:- Enum
enum HomeScreenState: Equatable {
    
    static func == (lhs: HomeScreenState, rhs: HomeScreenState) -> Bool {
        return lhs.getDisplayTest == rhs.getDisplayTest
    }
    
    case requestLocationPermission
    case locationPermissionDenied
    case fetchingWeatherInfo
    case parsingWeatherInfo
    case weatherDataAvailable(weatherInfos:[WeatherInfo])
    case error
    
    var getDisplayTest:String {
        get{
            switch self {
            case .requestLocationPermission:
                return "Waiting for current location"
            case .locationPermissionDenied:
                return "Location permission denied, we can't show weather info"
            case .fetchingWeatherInfo:
                return "Loading weather information..."
            case .parsingWeatherInfo:
                return "Parsing weather information..."
            case .weatherDataAvailable(_):
                return "Data is displayed"
            case .error:
                return "Opps!! something went wrong"
            }
        }
    }
}

//MARK:- Protocol
protocol HomeViewModelDelegate {
    func stateChange(newState:HomeScreenState)
}


//MARK:- ViewModel class
class HomeViewModel: NSObject {
        
    private let locationManager = CLLocationManager()
    private var currentState:HomeScreenState = .requestLocationPermission {
        didSet {
            self.delegate?.stateChange(newState: self.currentState)
        }
    }
    private var delegate:HomeViewModelDelegate?
    
    init(delegate:HomeViewModelDelegate) {
        super.init()
        self.delegate = delegate
        self.startUpdatingLocation()
    }
    
    //MARK:- Helper methods
    private func startUpdatingLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func numberOfRows() -> Int {
        switch self.currentState {
        case .weatherDataAvailable(let weatherInfos):
            return weatherInfos.count
        default:
            return 0
        }
    }
    
    func object(at indexPath:IndexPath) -> WeatherInfo? {
        switch self.currentState {
        case .weatherDataAvailable(let weatherInfos):
            return weatherInfos[indexPath.row]
        default:
            return nil
        }
    }
}

//MARK:- CLLocationManagerDelegate
extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            self.locationManager.requestLocation()
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            if self.currentState == .requestLocationPermission {
                self.currentState = .fetchingWeatherInfo
                APIHelper.shared.getWeatherInfo(latitude: "\(latitude)", longitude: "\(longitude)") { result in
                    switch result {
                    case .success(let responseData):
                        self.currentState = .parsingWeatherInfo
                        ResponseParser().parse(response: responseData) { result in
                            switch result {
                            case .success(let weatherInfos):
                                self.currentState = .weatherDataAvailable(weatherInfos: weatherInfos)
                            case .failure(_):
                                self.currentState = .error
                            }
                        }
                    case .failure(_):
                        self.currentState = .error
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Opps!!!Location access error")
        self.currentState = .error
    }
}
