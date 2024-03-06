//
//  RunningBottonSheetView.swift
//  FlabProject
//
//  Created by 김혜지 on 2/23/24.
//

import MapKit
import UIKit

protocol RunningBottomSheetViewProtocol: AnyObject {
    func tapPauseButton()
    func tapStopButton()
}

final class RunningBottonSheetView: UIView {
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsUserLocation = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "00km"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paceLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var runningInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [distanceLabel, paceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton(type: .custom)
        let configuration = UIImage.SymbolConfiguration(pointSize: 80)
        let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
        let action = UIAction { [weak self] _ in self?.tapPauseButton() }
        button.setImage(image, for: .normal)
        button.addAction(action, for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .custom)
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "stop.fill", withConfiguration: configuration)
        let action = UIAction { [weak self] _ in self?.tapStopButton() }
        button.setImage(image, for: .normal)
        button.addAction(action, for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private weak var delegate: RunningBottomSheetViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }
    
    private func addSubviews() {
        backgroundColor = .white
        
        addSubview(mapView)
        addSubview(runningInfoStackView)
        addSubview(timerLabel)
        addSubview(pauseButton)
        addSubview(stopButton)
        
        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            mapView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
            mapView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            distanceLabel.leadingAnchor.constraint(equalTo: runningInfoStackView.leadingAnchor),
            distanceLabel.topAnchor.constraint(equalTo: runningInfoStackView.topAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: runningInfoStackView.bottomAnchor),
            paceLabel.trailingAnchor.constraint(equalTo: runningInfoStackView.trailingAnchor),
            paceLabel.topAnchor.constraint(equalTo: runningInfoStackView.topAnchor),
            paceLabel.bottomAnchor.constraint(equalTo: runningInfoStackView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            runningInfoStackView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30),
            runningInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            runningInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: runningInfoStackView.bottomAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 30),
            pauseButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stopButton.leadingAnchor.constraint(equalTo: pauseButton.trailingAnchor, constant: 30),
            stopButton.centerYAnchor.constraint(equalTo: pauseButton.centerYAnchor)
        ])
    }
    
    func configure(delegate: RunningBottomSheetViewProtocol) {
        self.delegate = delegate
    }
    
    func update(location: Location) {
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func update(distance: String) {
        distanceLabel.text = distance
    }
    
    func update(time: String) {
        timerLabel.text = time
    }
    
    func tapPauseButton() {
        delegate?.tapPauseButton()
    }
    
    func tapStopButton() {
        delegate?.tapStopButton()
    }
}

#Preview {
    RunningBottonSheetView()
}
