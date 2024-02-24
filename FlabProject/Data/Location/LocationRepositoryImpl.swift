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
    private let manager: CLLocationManager
    private let coordinate: Coordinate
    
    private let publisher: PassthroughSubject<LocationOutput, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        coordinate = Coordinate()
        manager = CLLocationManager()
        manager.delegate = self.coordinate
        configure()
    }
    
    private func configure() {
        coordinate.transform()
            .receive(on: DispatchQueue.main)
            .sink { event in
                switch event {
                case let .didChangeAuthorization(isAuthorized):
                    self.publisher.send(.didChangeAuthorization(isAuthorized: isAuthorized))
                case let .didUpdate(location):
                    let latitude = location.latitude.magnitude
                    let longitude = location.longitude.magnitude
                    self.publisher.send(.didUpdate(location: .init(latitude: latitude, longitude: longitude)))
                }
            }
            .store(in: &cancellables)
    }
    
    func transform() -> AnyPublisher<LocationOutput, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func start() {
        manager.startUpdatingLocation()
    }
    
    func pause() {
        manager.stopUpdatingLocation()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    final class Coordinate: NSObject {
        var continuation: AsyncStream<CLLocationCoordinate2D>.Continuation?
        private let publisher: PassthroughSubject<Output, Never> = .init()
        
        func transform() -> AnyPublisher<Output, Never> {
            publisher.eraseToAnyPublisher()
        }
    }
}

extension LocationRepositoryImpl.Coordinate: CLLocationManagerDelegate {
    enum Output {
        case didChangeAuthorization(isAuthorized: Bool)
        case didUpdate(location: CLLocationCoordinate2D)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let isAuthorized = manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
        publisher.send(.didChangeAuthorization(isAuthorized: isAuthorized))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        publisher.send(.didUpdate(location: location))
    }
}
