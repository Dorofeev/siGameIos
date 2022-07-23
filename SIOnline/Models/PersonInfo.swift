//
//  PersonInfo.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

class PersonInfo: Decodable {
    var name: String
    var isReady: Bool
    var replic: String?
    var isDeciding: Bool
    var isHuman: Bool
    
    init(name: String, isReady: Bool, replic: String?, isDeciding: Bool, isHuman: Bool) {
        self.name = name
        self.isReady = isReady
        self.replic = replic
        self.isDeciding = isDeciding
        self.isHuman = isHuman
    }
}
