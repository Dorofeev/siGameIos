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
        let test = ChatViewController()
        let state = State.initialState()
        
        test.newState(state: state)
        test.setup { action in
            print(action)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.present(test, animated: true)
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

