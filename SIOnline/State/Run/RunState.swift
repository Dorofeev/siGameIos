//
//  RunState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

struct RunState {
    let persons: RunStatePersons
    let role: Role
    let answer: String?
    let lastReplic: ChatMessage?
    let stage: RunStateStage
    let timers: Timers
    let showMainTimer: Bool
    let table: TableState
    let selection: RunStateSelection
    let stakes: RunStateStakes
    let validation: RunStateValidation
    let chat: RunStateChat
    let selectedTableIndex: Int // 0 for showman; {N} for player {N - 1}
    let personsVisible: Bool
    let tablesVisible: Bool
    let isGameButtonEnabled: Bool
    let areSumsEditable: Bool
    let readingSpeed: Int
    let hint: String?
    
    static func runInitialState() -> RunState {
        RunState(
            persons: RunStatePersons(
                all: [:],
                showman: PersonInfo(
                    name: "",
                    isReady: false,
                    replic: nil,
                    isDeciding: false,
                    isHuman: true
                ),
                players: [],
                hostName: nil
            ),
            role: .Player,
            answer: nil,
            lastReplic: nil,
            stage: RunStateStage(
                name: "",
                isGamePaused: false,
                isGameStarted: false,
                isDecisionNeeded: false,
                isAnswering: false,
                isAfterQuestion: false,
                themeIndex: -1,
                currentPrice: 0,
                themeName: ""
            ),
            timers: Timers(
                round: TimerInfo(
                    isPausedBySystem: true,
                    isPausedByUser: false,
                    value: 0,
                    maximum: 0
                ),
                press: TimerInfo(
                    isPausedBySystem: true,
                    isPausedByUser: false,
                    value: 0,
                    maximum: 0
                ),
                decision: TimerInfo(
                    isPausedBySystem: true,
                    isPausedByUser: false,
                    value: 0,
                    maximum: 0
                )
            ),
            showMainTimer: false,
            table: TableState.initialState(),
            selection: RunStateSelection(
                isEnabled: false,
                message: ""
            ),
            stakes: RunStateStakes(
                areVisible: false,
                areSimple: false,
                allowedStakeTypes: [
                    .nominal: false,
                    .sum: false,
                    .pass: false,
                    .allIn: false
                ],
                minimum: 0,
                maximum: 0,
                step: 0,
                stake: 0,
                message: ""
            ),
            validation: RunStateValidation(
                isVisible: false,
                header: "",
                name: "",
                message: "",
                rightAnswers: [],
                wrongAnswers: []
            ),
            chat: RunStateChat(
                isVisible: false,
                isActive: false,
                mode: .chat,
                message: "",
                messages: [],
                selectedPersonName: nil
            ),
            selectedTableIndex: -1,
            personsVisible: false,
            tablesVisible: false,
            isGameButtonEnabled: true,
            areSumsEditable: false,
            readingSpeed: 20,
            hint: nil
        )
    }
}

struct RunStatePersons {
    let all: Persons
    let showman: PersonInfo
    let players: [PlayerInfo]
    let hostName: String?
}

struct RunStateStage {
    let name: String
    let isGamePaused: Bool
    let isGameStarted: Bool
    let isDecisionNeeded: Bool
    let isAnswering: Bool
    let isAfterQuestion: Bool
    let themeIndex: Int
    let currentPrice: Int
    let themeName: String
}

struct RunStateSelection {
    let isEnabled: Bool
    let message: String
}

struct RunStateStakes {
    let areVisible: Bool
    let areSimple: Bool
    let allowedStakeTypes: [StakeTypes: Bool]
    let minimum: Int
    let maximum: Int
    let step: Int
    let stake: Int
    let message: String
}

struct RunStateValidation {
    let isVisible: Bool
    let header: String
    let name: String
    let message: String
    let rightAnswers: [String]
    let wrongAnswers: [String]
}

struct RunStateChat {
    let isVisible: Bool
    let isActive: Bool
    let mode: ChatMode
    let message: String
    let messages: [ChatMessage]
    let selectedPersonName: String?
}
