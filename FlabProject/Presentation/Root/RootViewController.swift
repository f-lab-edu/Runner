//
//  RootViewController.swift
//  FlabProject
//
//  Created by 김혜지 on 2/23/24.
//

import UIKit

final class RootViewController: UITabBarController {
    private lazy var locationRepository = LocationRepositoryImpl()
    private lazy var pedometerRepository = PedometerRepositoryImpl()
    
    private lazy var runningService = RunningService(locationRepository: locationRepository, pedometerRepository: pedometerRepository)
    
    private lazy var historyViewController = HistoryViewController()
    private lazy var runningViewController = RunningViewController(service: runningService)
    private lazy var challengeViewController = ChallengeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
    }
    
    private func addSubViews() {
        view.backgroundColor = .systemBackground
        
        historyViewController.tabBarItem = .init(title: "기록", image: .init(systemName: "clock"), tag: 0)
        runningViewController.tabBarItem = .init(title: "러닝", image: .init(systemName: "figure.run"), tag: 1)
        challengeViewController.tabBarItem = .init(title: "챌린지", image: .init(systemName: "flame"), tag: 2)
        
        viewControllers = [historyViewController, runningViewController, challengeViewController]
        selectedIndex = 1
    }
}
