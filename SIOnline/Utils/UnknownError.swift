//
//  UnknownError.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 16.07.2022.
//

import Foundation
class UnknownError: NSError {
    init(message: String) {
        super.init(domain: "SIOnline", code: 500, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
