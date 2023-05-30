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
        let test = UsersListView()
        var state = State.initialState()
        state.online.users = ["QWERTY", "Kormak", "Hob a bob a"]
        state.user.login = "Kormak"
        test.newState(state: state)
        self.view.addEnclosedSubview(test)
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

