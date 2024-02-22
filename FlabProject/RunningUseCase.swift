//
//  RunningUseCase.swift
//  FlabProject
//
//  Created by 김혜지 on 2/13/24.
//

protocol RunningUseCase {
    func requestAuthorization()
    func start()
    func pause()
    func stop()
}
