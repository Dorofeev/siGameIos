//
//  TableState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

struct TableState {
    let mode: TableMode
    let caption: String
    let text: String
    let tail: String
    let animateReading: Bool
    let canPress: Bool
    let gameThemes: [String]
    let roundInfo: [ThemeInfo]
    let isSelectable: Bool
    let activeThemeIndex: Int
    let actionQuestionIndex: Int
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
