//
//  RunningService.swift
//  FlabProject
//
//  Created by 김혜지 on 2/13/24.
//

import Combine

final class RunningService: RunningUseCase {
    private let publisher: PassthroughSubject<RunningOutput, Never> = .init()
    private var cancellabels: Set<AnyCancellable> = .init()
    
    private let locationRepository: LocationRepository
    private let pedometerRepository: PedometerRepository
    
    init(
        locationRepository: LocationRepository = LocationRepositoryImpl(),
        pedometerRepository: PedometerRepository = PedometerRepositoryImpl()
    ) {
        self.locationRepository = locationRepository
        self.pedometerRepository = pedometerRepository
        configure()
    }
    
    private func configure() {
        locationRepository.transform()
            .sink { event in
                switch event {
                case let .didChangeAuthorization(isAuthorized):
                    self.publisher.send(.didChangeAuthorization(isAuthorized: isAuthorized))
                case let .didUpdate(location):
                    self.publisher.send(.didUpdateLocation(location))
                }
            }
            .store(in: &cancellabels)
        
        pedometerRepository.transform()
            .sink { distance in
                self.publisher.send(.didUpdateDistance(distance))
            }
            .store(in: &cancellabels)
    }
    
    func transform() -> AnyPublisher<RunningOutput, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    func start() {
        locationRepository.requestAuthorization()
        locationRepository.start()
        
        pedometerRepository.startUpdates()
    }
    
    func pause() {
        locationRepository.pause()
    }
    
    func stop() {
        locationRepository.stop()
    }
}
