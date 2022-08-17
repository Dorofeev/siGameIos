//
//  Input.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 15.08.2022.
//

import UIKit

class Input: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = R.color.inputBackground()
        self.layer.borderWidth = 1.0
    }

}
