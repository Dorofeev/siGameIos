//
//  GameErrorsHelper.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 29.05.2022.
//
class GameErrorsHelper {
    static let messagesMap: [Int: String] = [
        1: R.string.localizable.errorPackageNotFound(),
        2: R.string.localizable.errorTooManyGames(),
        3: R.string.localizable.errorServerUnderMaintainance(),
        4: R.string.localizable.badPackage(),
        5: R.string.localizable.errorDuplicateGameName(),
        6: R.string.localizable.errorInternalServerError(),
        7: R.string.localizable.errorServerNotReady(),
        8: R.string.localizable.errorObsoleteVersion(), // Неактуально для веб-версии
        9: R.string.localizable.unknownError(),
        10: R.string.localizable.joinError(),
        11: R.string.localizable.wrongGameSettings(),
        12: R.string.localizable.tooManyGamesByIp()
    ]
    
    static func getMessage(code: Int) -> String {
        return messagesMap[code] ?? R.string.localizable.unknownError()
    }
}
