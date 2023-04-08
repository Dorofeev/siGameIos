//
//  Input.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 15.08.2022.
//

import UIKit

class Input: UITextField {
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = R.color.inputBackground()
        self.layer.borderWidth = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
