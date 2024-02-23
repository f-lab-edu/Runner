//
//  RootViewController.swift
//  FlabProject
//
//  Created by 김혜지 on 2/23/24.
//

import UIKit

final class RootViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
    }
    
    private func addSubViews() {
        view.backgroundColor = .systemBackground
        
        let historyViewController = HistoryViewController()
        historyViewController.tabBarItem = .init(title: "기록", image: .init(systemName: "clock"), tag: 0)
        
        let runningViewController = RunningViewController()
        runningViewController.tabBarItem = .init(title: "러닝", image: .init(systemName: "figure.run"), tag: 1)
        
        let challengeViewController = ChallengeViewController()
        challengeViewController.tabBarItem = .init(title: "챌린지", image: .init(systemName: "flame"), tag: 2)
        
        viewControllers = [historyViewController, runningViewController, challengeViewController]
    }
}
