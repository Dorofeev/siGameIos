//
//  TableActions.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 23.04.2022.
//

import ReSwift
typealias KnownTableAction = TableActionTypes

enum TableActionTypes: Action {
    case showLogo
    case showGameThemes(gameThemes: [String])
    case showRoundThemes(roundThemes: [ThemeInfo], isFinal: Bool, display: Bool)
    case showText(text: String, animateReading: Bool)
    case showAnswer(text: String)
    case showRoundTable
    case blinkQuestion(themeIndex: Int, questionIndex: Int)
    case blinkTheme(themeIndex: Int)
    case removeQuestion(themeIndex: Int, questionIndex: Int)
    case removeTheme(themeIndex: Int)
    case showPartialText(textShape: String)
    case appendPatrialText(text: String)
    case showImage(uri: String)
    case showAudio(uri: String)
    case showVideo(uri: String)
    case showSpecial(text: String, activeThemeIndex: Int)
    case canPressChanged(canPress: Bool)
    case isSelectableChanged(isSelectable: Bool)
    case resumeMedia
    case captionChanged(caption: String)
}
