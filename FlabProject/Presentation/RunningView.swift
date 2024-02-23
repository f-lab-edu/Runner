//
//  RunningView.swift
//  FlabProject
//
//  Created by 김혜지 on 2/14/24.
//

import UIKit

protocol RunningViewProtocol: AnyObject {
    func tapStartButton()
}

final class RunningView: UIView {
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .custom)
        let configuration = UIImage.SymbolConfiguration(pointSize: 80)
        let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
        let action = UIAction { [weak self] _ in self?.tapStartButton() }
        button.setImage(image, for: .normal)
        button.addAction(action, for: .touchUpInside)
        button.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private weak var delegate: RunningViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubViews()
    }
    
    private func addSubViews() {
        addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(delegate: RunningViewProtocol) {
        self.delegate = delegate
    }
    
    func tapStartButton() {
        delegate?.tapStartButton()
    }
}

#Preview {
    RunningView()
}
