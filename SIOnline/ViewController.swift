//
//  ViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var progressBar: ProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let test = ChatInputEmojiPicker()
        view.addSubview(test, activateConstraints: [
            test.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            test.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        test.onEmojiClick = { emoji in
            print(emoji)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func showError(error: Error) {
        print("some error \(error)")
    }
    
    func showError(message: String) {
        print("some error \(message)")
    }
}

