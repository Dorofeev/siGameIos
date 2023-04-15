//
//  MentionHelpers.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 15.04.2023.
//

import Foundation

class MentionHelpers {
    static func hasUserMentioned(message: String, user: String) -> Bool {
        let pattern = "@\(user)\\W"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: message.utf16.count)
        return regex.firstMatch(in: message, options: [], range: range) != nil
    }
}
