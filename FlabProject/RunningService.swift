//
//  RunningService.swift
//  FlabProject
//
//  Created by 김혜지 on 2/13/24.
//

struct RunningService: RunningUseCase {
    let repository: LocationRepository
    
    init(repository: LocationRepository) {
        self.repository = repository
    }
    
    func requestAuthorization() {
        self.repository.requestAuthorization()
    }
    
    func start() {
        self.repository.start()
    }
    
    func pause() {
        self.repository.pause()
    }
    
    func stop() {
        self.repository.stop()
    }
}
