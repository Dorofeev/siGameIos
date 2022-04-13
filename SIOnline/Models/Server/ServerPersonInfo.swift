//
//  ServerPersonInfo.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 11.04.2022.
//

class ServerPersonInfo {
    let isOnline: Bool
    let name: String
    let role: Int
    
    init(isOnline: Bool, name: String, role: Int) {
        self.isOnline = isOnline
        self.name = name
        self.role = role
    }
}
