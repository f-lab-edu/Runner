//
//  PedometerRepository.swift
//  FlabProject
//
//  Created by 김혜지 on 2/24/24.
//

import Combine

protocol PedometerRepository {
    func transform() -> AnyPublisher<Int, Never>
    
    func startUpdates()
    func stopUpdates()
}
