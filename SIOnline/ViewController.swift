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
        view.backgroundColor = R.color.backgroundColor()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let test = UsersViewController()
        var state = State.initialState()
        state.online.users = ["QWERTY", "Kormak", "Hob a bob a"]
        state.user.login = "Kormak"
        state.settingsState.isLobbyChatHidden = false
        state.online.chatMode = .users
        test.newState(state: state)
        test.setup { action in
            print(action)
        }
        self.present(test, animated: true)
        
    }
    func showError(error: Error) {
        print("some error \(error)")
    }
    
    func showError(message: String) {
        print("some error \(message)")
    }
}

