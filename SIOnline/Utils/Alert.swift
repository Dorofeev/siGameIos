//
//  Alert.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 11.07.2022.
//

import UIKit

func alert(text: String) {
    for scene in UIApplication.shared.connectedScenes {
        if scene.activationState == .foregroundActive {
            if let rootVC = ((scene as? UIWindowScene)?.delegate as? UIWindowSceneDelegate)?.window??.rootViewController {
                let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                rootVC.present(alertController, animated: true, completion: nil)
                break
            }
        }
    }
}
