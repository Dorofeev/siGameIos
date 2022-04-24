//
//  TableState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

struct TableState {
    var mode: TableMode
    var caption: String
    var text: String
    var tail: String
    var animateReading: Bool
    var canPress: Bool
    var gameThemes: [String]
    var roundInfo: [ThemeInfo]
    var isSelectable: Bool
    var activeThemeIndex: Int
    var actionQuestionIndex: Int
    var isMediaStopped: Bool
    
    static func initialState() -> TableState {
        TableState(
            mode: .text,
            caption: "",
            text: R.string.localizable.tableHint(),
            tail: "",
            animateReading: false,
            canPress: false,
            gameThemes: [],
            roundInfo: [],
            isSelectable: false,
            activeThemeIndex: -1,
            actionQuestionIndex: -1,
            isMediaStopped: false
        )
    }
}
