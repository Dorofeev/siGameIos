//
//  GameInfoViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 04.11.2022.
//

import UIKit

class GameInfoViewController: UIViewController {
    
    // color: white;
    
    // MARK: - Views
    
    private lazy var innerInfoView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.backgroundColor = R.color.gameinfoBackground()
    }
    
    private func setupLayout() {
        view.addEnclosedSubview(innerInfoView, insets: NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
    }
}
