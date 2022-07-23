//
//  GameInfo.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 11.04.2022.
//

struct GameInfo: Decodable {
    let gameID: Int
    let gameName: String
    let language: String
    let mode: GameType
    let owner: String
    let packageName: String
    let passwordRequired: Bool
    let persons: [PersonInfo]
    let realStartTime: String
    let rules: Int
    let stage: Int
    let stageName: String
    let started: Bool
    let startTime: String
}
