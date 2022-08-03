//
//  File.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 18.07.2022.
//

import Foundation

class File {
    let data: Data
    let name: String
    
    init(data: Data, name: String) {
        self.data = data
        self.name = name
    }
}
