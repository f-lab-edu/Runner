//
//  LocationRepository.swift
//  FlabProject
//
//  Created by 김혜지 on 2/12/24.
//

import Combine

enum LocationOutput {
    case didChangeAuthorization(isAuthorized: Bool)
    case didUpdate(location: Location)
}

protocol LocationRepository {
    func transform() -> AnyPublisher<LocationOutput, Never>
    
    func requestAuthorization()
    func start()
    func pause()
    func stop()
}
