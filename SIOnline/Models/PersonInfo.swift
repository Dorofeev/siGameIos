//
//  PersonInfo.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

class PersonInfo {
    var name: String
    let isReady: Bool
    var replic: String?
    let isDeciding: Bool
    let isHuman: Bool
    
    init(name: String, isReady: Bool, replic: String?, isDeciding: Bool, isHuman: Bool) {
        self.name = name
        self.isReady = isReady
        self.replic = replic
        self.isDeciding = isDeciding
        self.isHuman = isHuman
    }
}
