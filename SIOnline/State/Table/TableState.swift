//
//  TableState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

struct TableState {
    var mode: TableMode
    let caption: String
    var text: String
    var tail: String
    var animateReading: Bool
    let canPress: Bool
    var gameThemes: [String]
    var roundInfo: [ThemeInfo]
    let isSelectable: Bool
    var activeThemeIndex: Int
    var actionQuestionIndex: Int
    let isMediaStopped: Bool
    
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
