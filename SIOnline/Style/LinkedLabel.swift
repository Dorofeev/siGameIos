//
//  LinkedLabel.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 28.08.2022.
//

import UIKit

class LinkedLabel: UILabel {
    
    private var url: String = ""

    func setUrl(title: String, url: String) {
        self.attributedText = NSAttributedString(
            string: title,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single,
                .underlineColor: UIColor.blue,
                .foregroundColor: UIColor.blue
            ])
        
        self.url = url
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    func setListedUrl(title: String, url: String) {
        setUrl(title: title, url: url)
        let listText = NSMutableAttributedString(string: "• ")
        listText.append(self.attributedText!)
        self.attributedText = listText
    }
    
    @objc private func onTap() {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
}
