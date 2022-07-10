//
//  RunActions.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 20.04.2022.
//

import ReSwift

typealias KnownRunAction = RunActionTypes

enum RunActionTypes: Action {
    case runChatModeChanged(chatMode: ChatMode)
    case runChatMessageChanged(message: String)
    case runChatVisibilityChanged(isOpen: Bool)
    case runShowPersons
    case runHidePersons
    case runShowTables
    case runHideTables
    case chatMessageAdded(chatMessage: ChatMessage)
    case lastReplicChanged(chatMessage: ChatMessage?)
    case activateChat
    case showmanReplicChanged(replic: String)
    case playerReplicChanged(playerIndex: Int, replic: String)
    case infoChanged(all: Persons, showman: PersonInfo, players: [PlayerInfo])
    case chatPersonSelected(personName: String)
    case tableSelected(tableIndex: Int)
    case personAvatarChanged(personName: String, avatarUri: String)
    case gameStarted
    case stageChanged(stageName: String, roundIndex: Int)
    case playersStateCleared
    case gameStateCleared
    case sumsChanged(sums: [Int])
    case afterQuestionStateChanged(isAfterQuestion: Bool)
    case currentPriceChanged(currentPrice: Int)
    case personAdded(person: Account)
    case personRemoved(name: String)
    case showmanChanged(name: String, isHuman: Bool?, isReady: Bool?)
    case playerAdded
    case playerChanged(index: Int, name: String, isHuman: Bool?, isReady: Bool?)
    case playerDeleted(index: Int)
    case playersSwap(index1: Int, index2: Int)
    case roleChanged(role: Role)
    case playerStateChanged(index: Int, state: PlayerStates)
    case playerLostStateDropped(index: Int)
    case isPausedChanged(isPaused: Bool)
    case playerStakeChanged(index: Int, stake: Int)
    case decisionNeededChanged(decisionNeeded: Bool)
    case clearDecisions
    case isGameButtonEnabledChanged(isGameButtonEnabled: Bool)
    case isAnswering
    case answerChanged(answer: String)
    case validateAction(
        name: String,
        answer: String,
        rightAnswers: [String],
        wrongAnswers: [String],
        header: String,
        message: String
    )
    case setStakes(
        allowedStakeTypes: [StakeTypes: Bool],
        minimum: Int,
        maximum: Int,
        stake: Int,
        step: Int,
        message: String,
        areSimple: Bool
    )
    case stakeChanged(stake: Int)
    case selectionEnabled(allowedIndices: [Int], message: String)
    case areSumsEditableChanged(areSumsEditable: Bool)
    case readingSpeedChanged(readingSpeed: Int)
    case runTimer(timerIndex: Int, maximumTime: Int, runByUser: Bool)
    case pauseTimer(timerIndex: Int, currentTime: Int, pausedByUser: Bool)
    case resumeTimer(timerIndex: Int, runByUser: Bool)
    case stopTimer(timerIndex: Int)
    case timerMaximumChanged(timerIndex: Int, maximumTime: Int)
    case activateShowmanDecision
    case activatePlayerDecision(playerIndex: Int)
    case showMainTimer
    case clearDecisionsAndMainTimer
    case hintChanged(hint: String?)
    case operationError(error: String)
    case hostNameChanged(hostName: String?)
    case themeNameChanged(themeName: String)
    case isReadyChanged(personIndex: Int, isReady: Bool)
    case roundsNamesChanged(roundsNames: [String])
}
