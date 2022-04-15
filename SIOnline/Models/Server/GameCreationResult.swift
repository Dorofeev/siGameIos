//
//  GameCreationResult.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 14.04.2022.
//

struct GameCreationResult {
    let code: GameCreationResultCode
    let errorMessage: String
    let gameId: Int
    let isHost: Bool /* Obsolete */
}
