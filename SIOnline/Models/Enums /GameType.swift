//
//  GameType.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

enum GameType: Int, Codable {
    case Classic = 0
    case Simple = 1
    
    func toString() -> String {
        switch self {
        case .Classic:
            return "Classic"
        case .Simple:
            return "Simple"
        }
    }
}
