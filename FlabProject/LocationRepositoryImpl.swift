//
//  LocationRepositoryImpl.swift
//  FlabProject
//
//  Created by 김혜지 on 2/12/24.
//

import Combine
import CoreLocation
import Foundation

final class LocationRepositoryImpl: LocationRepository {
    let manager: CLLocationManager = CLLocationManager()
    
    private var cancellables: Set<AnyCancellable> = []
    private var coordinate: Coordinate?
    
    private var authorizationStatus: CLAuthorizationStatus {
        self.manager.authorizationStatus
    }
    
    init() {}
    
    func requestAuthorization() {
        self.manager.requestWhenInUseAuthorization()
    }
    
    func start() {
        self.coordinate = Coordinate()
        self.manager.delegate = self.coordinate
        self.coordinate?.transform()
            .receive(on: DispatchQueue.main)
            .sink { event in
                switch event {
                case let .update(location):
                    break
                }
            }
            .store(in: &cancellables)
        
        self.manager.startUpdatingLocation()
    }
    
    func pause() {
        self.manager.stopUpdatingLocation()
    }
    
    func stop() {
        self.manager.stopUpdatingLocation()
    }
    
    final class Coordinate: NSObject {
        private let publisher: PassthroughSubject<Output, Never> = .init()
        
        func transform() -> AnyPublisher<Output, Never> {
            self.publisher.eraseToAnyPublisher()
        }
    }
}

extension LocationRepositoryImpl.Coordinate: CLLocationManagerDelegate {
    enum Output {
        case update(location: CLLocationCoordinate2D)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        self.publisher.send(.update(location: location))
    }
}
