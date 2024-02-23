//
//  RunningViewController.swift
//  FlabProject
//
//  Created by 김혜지 on 2/2/24.
//

import Combine
import UIKit

final class RunningViewController: UIViewController {
    private lazy var runningView: RunningView = {
        let view = RunningView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var locations: [Location] = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let service: RunningUseCase
    
    init(service: RunningUseCase = RunningService()) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
    }
    
    private func configure() {
        service.transform()
            .sink { event in
                switch event {
                case let .didChangeAuthorization(isAuthorized):
                    break
                case let .didUpdate(location):
                    self.locations.append(location)
                }
            }
            .store(in: &cancellables)
    }

    private func addSubViews() {
        view.backgroundColor = .systemBackground
        
        runningView.configure(delegate: self)
        
        view.addSubview(runningView)
        
        NSLayoutConstraint.activate([
            runningView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            runningView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            runningView.heightAnchor.constraint(equalTo: view.heightAnchor),
            runningView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension RunningViewController: RunningViewProtocol {
    func tapStartButton() {
        service.start()
    }
}
