//
//  BottomSheetViewController.swift
//  FlabProject
//
//  Created by 김혜지 on 2/23/24.
//

import UIKit

final class BottomSheetViewController<Content: UIView>: UIViewController {
    private let content: Content
    
    init(content: Content) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
    }
    
    private func addSubViews() {
        content.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(content)
        
        NSLayoutConstraint.activate([
            content.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            content.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            content.heightAnchor.constraint(equalTo: view.heightAnchor),
            content.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
