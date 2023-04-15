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
        let test = ChatLogView()
        view.addEnclosedSubview(test)
        test.setMessages([
            ChatMessage(sender: "Kormak", text: "Test message", messageLevel: .information),
            ChatMessage(sender: "", text: "Test message 2", messageLevel: .information),
            ChatMessage(sender: "Kormak", text: "Test message 3", messageLevel: .system),
            ChatMessage(sender: "", text: "Test message 4", messageLevel: .system),
            ChatMessage(sender: "Kormak", text: "Test message 6", messageLevel: .warning),
            ChatMessage(sender: "", text: "Test message 5", messageLevel: .warning)
        ])
        test.setOnNicknameClick {
            print($0)
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

