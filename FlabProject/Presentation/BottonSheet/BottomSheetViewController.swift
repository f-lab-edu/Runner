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
    
    override func loadView() {
        view = content
    }
}
