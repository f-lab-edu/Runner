//
//  RunningViewController.swift
//  FlabProject
//
//  Created by 김혜지 on 2/2/24.
//

import Combine
import MapKit
import UIKit

final class RunningViewController: UIViewController {
    private lazy var runningBottomSheetView = RunningBottonSheetView()
    private lazy var runningView: RunningView = RunningView()
    
    private var isAuthorized: Bool = false
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let service: RunningUseCase
    
    private var seconds: Int = 0
    private var timer: Timer?
    
    init(service: RunningUseCase) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = runningView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        runningView.configure(delegate: self)
        
        service.transform()
            .sink { event in
                switch event {
                case let .didChangeAuthorization(isAuthorized):
                    self.isAuthorized = isAuthorized
                case let .didUpdateLocation(location):
                    self.runningBottomSheetView.update(location: location)
                case let .didUpdateDistance(distance):
                    self.runningBottomSheetView.update(distance: distance.description)
                }
            }
            .store(in: &cancellables)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.seconds += 1
            self.runningBottomSheetView.update(time: self.seconds.description)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    private func presentBottomSheet() {
        runningBottomSheetView.configure(delegate: self)
        
        let bottomSheetViewcontroller = BottomSheetViewController(content: runningBottomSheetView)
        let navigationController = UINavigationController(rootViewController: bottomSheetViewcontroller)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.large()]
        }
        
        present(navigationController, animated: true, completion: {})
    }
}

extension RunningViewController: RunningViewProtocol {
    func tapStartButton() {
        service.start()
        startTimer()
        presentBottomSheet()
    }
}

extension RunningViewController: RunningBottomSheetViewProtocol {
    func tapPauseButton() {
        service.pause()
    }
    
    func tapStopButton() {
        service.stop()
    }
}

extension RunningViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {}
}
