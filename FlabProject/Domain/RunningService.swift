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
    
    private let repository: LocationRepository
    
    init(repository: LocationRepository = LocationRepositoryImpl()) {
        self.repository = repository
        configure()
    }
    
    private func configure() {
        self.repository.transform()
            .sink { event in
                switch event {
                case let .didChangeAuthorization(isAuthorized):
                    self.publisher.send(.didChangeAuthorization(isAuthorized: isAuthorized))
                case let .didUpdate(location):
                    self.publisher.send(.didUpdate(location: location))
                }
            }
            .store(in: &cancellabels)
    }
    
    func transform() -> AnyPublisher<RunningOutput, Never> {
        self.publisher.eraseToAnyPublisher()
    }
    
    func start() {
        self.repository.requestAuthorization()
        self.repository.start()
    }
    
    func pause() {
        self.repository.pause()
    }
    
    func stop() {
        self.repository.stop()
    }
}
