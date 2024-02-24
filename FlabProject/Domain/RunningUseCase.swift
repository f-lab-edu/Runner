//
//  RunningUseCase.swift
//  FlabProject
//
//  Created by 김혜지 on 2/13/24.
//

import Combine

enum RunningOutput {
    case didChangeAuthorization(isAuthorized: Bool)
    case didUpdate(location: Location)
}

protocol RunningUseCase {
    func transform() -> AnyPublisher<RunningOutput, Never>
    
    func start()
    func pause()
    func stop()
}
