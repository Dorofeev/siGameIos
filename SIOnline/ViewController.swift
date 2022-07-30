//
//  ViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

import UIKit

class ViewController: UIViewController {
    let test = Index()
    
    var progressBar: ProgressBar = {
        let bar = ProgressBar.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    func showError(error: Error) {
        print("some error \(error)")
    }
    
    func showError(message: String) {
        print("some error \(message)")
    }
}

