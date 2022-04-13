//
//  SavedState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.04.2022.
//

import Foundation
import Alamofire

private let stateKey = "SIOnline_State"

struct SavedState: Codable {
    let login: String
    let game: SavedStateGame?
    let settings: SettingsState?
    
    static func loadState() -> SavedState? {
        guard let base64 = UserDefaults.standard.string(forKey: stateKey),
              let data = Data(base64Encoded: base64),
              let decodedData = try? JSONDecoder().decode(SavedState.self, from: data)else {
                  return nil
              }
        
        return decodedData
    }
}

struct SavedStateGame: Codable {
    let name: String
    let password: String
    let role: Role
    let type: GameType
    let playersCount: Int
}
