//
//  PackageKey.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//

struct PackageKey: Codable {
    let name: String?
    let hash: String?
    let id: String?
    
    init(name: String?, hash: String?, id: String?) {
        self.name = name
        self.hash = hash
        self.id = id
    }
}
