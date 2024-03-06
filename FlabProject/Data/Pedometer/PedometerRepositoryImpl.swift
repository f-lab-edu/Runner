//
//  PedometerRepositoryImpl.swift
//  FlabProject
//
//  Created by 김혜지 on 2/24/24.
//

import Combine
import CoreMotion

final class PedometerRepositoryImpl: PedometerRepository {
    private let publisher: PassthroughSubject<Int, Never> = .init()
    
    private let pedometer = CMPedometer()
    
    init() {}
    
    func transform() -> AnyPublisher<Int, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    func startUpdates() {
        guard CMPedometer.isDistanceAvailable() else { return }
        pedometer.startUpdates(from: Date()) { data, error in
            guard let distance = data?.distance?.intValue else { return }
            self.publisher.send(distance)
        }
    }
    
    func stopUpdates() {
        pedometer.stopUpdates()
    }
}
