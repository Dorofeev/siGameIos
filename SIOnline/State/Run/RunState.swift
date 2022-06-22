//
//  RunState.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

struct RunState {
    var persons: RunStatePersons
    var role: Role
    var answer: String?
    var lastReplic: ChatMessage?
    var stage: RunStateStage
    var timers: Timers
    var showMainTimer: Bool
    var table: TableState
    var selection: RunStateSelection
    var stakes: RunStateStakes
    var validation: RunStateValidation
    var chat: RunStateChat
    var selectedTableIndex: Int // 0 for showman; {N} for player {N - 1}
    var personsVisible: Bool
    var tablesVisible: Bool
    var isGameButtonEnabled: Bool
    var areSumsEditable: Bool
    var readingSpeed: Int
    var hint: String?
    
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
                themeName: "",
                roundIndex: -1
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
    var all: Persons
    var showman: PersonInfo
    var players: [PlayerInfo]
    var hostName: String?
}

struct RunStateStage {
    var name: String
    var isGamePaused: Bool
    var isGameStarted: Bool
    var isDecisionNeeded: Bool
    var isAnswering: Bool
    var isAfterQuestion: Bool
    let themeIndex: Int
    var currentPrice: Int
    var themeName: String
    var roundIndex: Int
}

struct RunStateSelection {
    var isEnabled: Bool
    var message: String
}

struct RunStateStakes {
    var areVisible: Bool
    var areSimple: Bool
    var allowedStakeTypes: [StakeTypes: Bool]
    var minimum: Int
    var maximum: Int
    var step: Int
    var stake: Int
    var message: String
}

struct RunStateValidation {
    var isVisible: Bool
    var header: String
    var name: String
    var message: String
    var rightAnswers: [String]
    var wrongAnswers: [String]
}

struct RunStateChat {
    var isVisible: Bool
    var isActive: Bool
    var mode: ChatMode
    var message: String
    var messages: [ChatMessage]
    var selectedPersonName: String?
}
