//
//  GameCreationResultCode.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 14.04.2022.
//

enum GameCreationResultCode {
    case ok
    case noPackage
    case tooMuchGames
    case serverUnderMaintainance
    case badPackage
    case gameNameCollision
    case internalServerError
    case serverNotReady
    case yourClientIsObsolete
    case unknownError
    case joinError
    case wrongGameSettings
    case tooManyGamesByAddress
}
