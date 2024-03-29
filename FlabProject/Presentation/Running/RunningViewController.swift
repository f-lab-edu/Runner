//
//  RunningViewController.swift
//  FlabProject
//
//  Created by 김혜지 on 2/2/24.
//

import Combine
import UIKit

final class RunningViewController: UIViewController {
    private lazy var runningBottomSheetView = RunningBottonSheetView()
    
    private lazy var testCrashButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Test Crash", for: [])
        let action = UIAction { [weak self] _ in self?.sendCrash() }
        button.addAction(action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var runningView: RunningView = {
        let view = RunningView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isAuthorized: Bool = false
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
                    self.isAuthorized = isAuthorized
                case let .didUpdateLocation(location):
                    self.runningBottomSheetView.update(location: location)
                case let .didUpdateDistance(distance):
                    self.runningBottomSheetView.update(distance: Double(distance))
                }
            }
            .store(in: &cancellables)
    }

    private func addSubViews() {
        view.backgroundColor = .systemBackground
        
        runningView.configure(delegate: self)
        
        view.addSubview(runningView)
        view.addSubview(testCrashButton)
        
        NSLayoutConstraint.activate([
            runningView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            runningView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            runningView.heightAnchor.constraint(equalTo: view.heightAnchor),
            runningView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            testCrashButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testCrashButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
    }
    
    private func presentBottomSheet() {
        let bottomSheetViewcontroller = BottomSheetViewController(content: runningBottomSheetView)
        let navigationController = UINavigationController(rootViewController: bottomSheetViewcontroller)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
        }
        
        present(navigationController, animated: true, completion: {})
    }
    
    private func sendCrash() {
        let numbers = [0]
        let _ = numbers[1]
    }
}

extension RunningViewController: RunningViewProtocol {
    func tapStartButton() {
        service.start()
        presentBottomSheet()
    }
}
