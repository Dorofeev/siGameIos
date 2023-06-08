//
//  PackageFilters.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 23.07.2022.
//

struct PackageFilters {
    var difficultyRelation: Int
    var difficulty: Int
    var authorId: Int?
    var sortMode: Int
    var sortAscending: Bool
    var publisherId: Int?
    var tagId: Int?
    var restriction: String?
    
    static func initial() -> PackageFilters {
        return PackageFilters(difficultyRelation: 0, difficulty: 1, sortMode: 0, sortAscending: true)
    }
    
    var dictionaryValue: [String: String] {
        var result = [
            "difficultyRelation": String(difficultyRelation),
            "difficulty": String(difficulty),
            "sortMode": String(sortMode),
            "sortAscending": String(sortAscending)
        ]
        
        if let authorId {
            result["authorId"] = String(authorId)
        }
        if let publisherId {
            result["publisherId"] = String(publisherId)
        }
        if let tagId {
            result["tagId"] = String(tagId)
        }
        if let restriction {
            result["restriction"] = String(restriction)
        }
        return result
    }
}
