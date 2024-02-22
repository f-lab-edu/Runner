//
//  LocationRepository.swift
//  FlabProject
//
//  Created by 김혜지 on 2/12/24.
//

protocol LocationRepository {
    func requestAuthorization()
    func start()
    func pause()
    func stop()
}
