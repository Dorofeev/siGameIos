//
//  runReducer.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 25.04.2022.
//

import ReSwift

let runReducer: Reducer<RunState> = { action, state in
    var state = state ?? RunState.runInitialState()
    
    guard let action = action as? KnownRunAction else { return state }
    
    switch action {
    case .runChatModeChanged(let chatMode):
        state.chat.mode = chatMode
    case .runChatMessageChanged(let message):
        state.chat.message = message
    case .runChatVisibilityChanged(let isOpen):
        state.chat.isVisible = isOpen
        if isOpen {
            state.chat.isActive = false
        }
    case .runShowPersons:
        state.personsVisible = true
    case .runHidePersons:
        state.personsVisible = false
    case .runShowTables:
        state.tablesVisible = true
    case .runHideTables:
        state.tablesVisible = false
    case .lastReplicChanged(let chatMessage):
        state.lastReplic = chatMessage
        if chatMessage != nil {
            state.chat.isActive = true
        }
    case .activateChat:
        state.chat.isActive = true
    case .showmanReplicChanged(let replic):
        state.persons.showman.replic = replic
        state.persons.players.forEach({ $0.replic = nil })
    case .playerReplicChanged(let playerIndex, let replic):
        state.persons.showman.replic = nil
        for (index, player) in state.persons.players.enumerated() {
            player.replic = index == playerIndex ? replic : nil
        }
    case .infoChanged(let all, let showman, let players):
        state.persons.all = all
        state.persons.showman = showman
        state.persons.players = players
        
    case .chatPersonSelected(let personName):
        state.chat.selectedPersonName = personName
    case .tableSelected(let tableIndex):
        state.selectedTableIndex = tableIndex
    case .personAvatarChanged(let personName, let avatarUri):
        state.persons.all[personName]?.avatar = avatarUri
    case .gameStarted:
        state.stage.isGameStarted = true
    case .stageChanged(let stageName, let roundIndex):
        state.stage.name = stageName
        state.stage.roundIndex = roundIndex
    case .playersStateCleared:
        state.persons.players.forEach { playerInfo in
            playerInfo.state = .none
            playerInfo.stake = 0
        }
    case .gameStateCleared:
        state.stage.isAfterQuestion = false
        state.stage.isAnswering = false
        state.stage.isDecisionNeeded = false
        state.persons.players.forEach { playerInfo in
            playerInfo.canBeSelected = false
        }
        state.validation.isVisible = false
        state.stakes.areVisible = false
        state.stakes.areSimple = false
        state.table.isSelectable = false
        state.table.caption = ""
    case .sumsChanged(let sums):
        state.persons.players.enumerated().forEach { index, playerInfo in
            playerInfo.sum = index < sums.count ? sums[index] : 0
        }
    case .afterQuestionStateChanged(let isAfterQuestion):
        state.stage.isAfterQuestion = isAfterQuestion
    case .currentPriceChanged(let currentPrice):
        state.stage.currentPrice = currentPrice
    case .personAdded(let person):
        if (state.persons.all[person.name] != nil) {
            Logger.log(message: "Person \(person.name) already exists!")
        }
        state.persons.all.setItem(key: person.name, item: person)
    case .personRemoved(let name):
        state.persons.all.remove(key: name)
    case .showmanChanged(let name, let isHuman, let isReady):
        state.persons.showman.name = name
        if let isHuman = isHuman {
            state.persons.showman.isHuman = isHuman
        }
        if let isReady = isReady {
            state.persons.showman.isReady = isReady
        }
    case .playerAdded:
        state.persons.players.append(
            PlayerInfo(
                name: Constants.anyName,
                isReady: false,
                replic: nil,
                isDeciding: false,
                isHuman: true,
                sum: 0,
                stake: 0,
                state: .none,
                canBeSelected: false,
                isChooser: false,
                inGame: true
            )
        )
    case .playerChanged(let index, let name, let isHuman, let isReady):
        if index < 0 || index >= state.persons.players.count {
            Logger.log(message: "PlayerChanged: Wrong index \(index)!")
            break
        }
        state.persons.players[index].name = name
        if let isHuman = isHuman {
            state.persons.players[index].isHuman = isHuman
        }
        if let isReady = isReady {
            state.persons.players[index].isReady = isReady
        }
    case .playerDeleted(let index):
        if index < 0 || index >= state.persons.players.count {
            Logger.log(message: "PlayerDeleted: Wrong index \(index)!")
            break
        }
        state.persons.players.remove(at: index)
    case .playersSwap(let index1, let index2):
        state.persons.players.swapAt(index1, index2)
    case .roleChanged(let role):
        state.role = role
    case .playerStateChanged(let index, let actionState):
        state.persons.players[index].state = actionState
    case .playerLostStateDropped(let index):
        if index < 0 || index >= state.persons.players.count {
            Logger.log(message: "PlayerLostStateDropped: Wrong index \(index)!")
            break
        }
        if state.persons.players[index].state != PlayerStates.lost {
            break
        }
        state.persons.players[index].state = .none
    case .isPausedChanged(let isPaused):
        state.stage.isGamePaused = isPaused
    case .playerStakeChanged(let index, let stake):
        state.persons.players[index].stake = stake
    case .decisionNeededChanged(let decisionNeeded):
        state.stage.isDecisionNeeded = decisionNeeded
    case .clearDecisions:
        state.persons.players.forEach { playerInfo in
            playerInfo.canBeSelected = false
        }
        state.stage.isAnswering = false
        state.stage.isDecisionNeeded = false
        state.validation.isVisible = false
        state.table.isSelectable = false
        state.selection.isEnabled = false
        state.stakes.areSimple = false
        state.stakes.areVisible = false
        state.answer = nil
        state.hint = nil
    case .isGameButtonEnabledChanged(let isGameButtonEnabled):
        state.isGameButtonEnabled = isGameButtonEnabled
    case .isAnswering:
        state.stage.isAnswering = true
        state.stage.isDecisionNeeded = true
        state.answer = nil
    case .answerChanged(let answer):
        state.answer = answer
    case .validateAction(let name, let answer, let rightAnswers, let wrongAnswers, let header, let message):
        state.answer = answer
        state.validation.isVisible = true
        state.validation.rightAnswers = rightAnswers
        state.validation.wrongAnswers = wrongAnswers
        state.validation.header = header
        state.validation.name = name
        state.validation.message = message
    case .setStakes(let allowedStakeTypes, let minimum, let maximum, let stake, let step, let message, let areSimple):
        state.stakes.areVisible = true
        state.stakes.areSimple = areSimple
        state.stakes.allowedStakeTypes = allowedStakeTypes
        state.stakes.minimum = minimum
        state.stakes.maximum = maximum
        state.stakes.stake = stake
        state.stakes.step = step
        state.stakes.message = message
    case .stakeChanged(let stake):
        state.stakes.stake = stake
    case .selectionEnabled(let allowedIndices, let message):
        state.persons.players.enumerated().forEach { (index, value) in
            value.canBeSelected = allowedIndices.contains(index)
        }
        state.selection.isEnabled = true
        state.selection.message = message
        state.stage.isDecisionNeeded = true
    case .areSumsEditableChanged(let areSumsEditable):
        state.areSumsEditable = areSumsEditable
    case .readingSpeedChanged(let readingSpeed):
        state.readingSpeed = readingSpeed
    case .runTimer(let timerIndex, let maximumTime, let runByUser):
        state.timers.updateTimers(timerIndex: timerIndex) { timerInfo in
            if runByUser {
                timerInfo.isPausedByUser = false
            } else {
                timerInfo.isPausedBySystem = false
            }
            timerInfo.maximum = maximumTime
            timerInfo.value = 0
        }
    case .pauseTimer(let timerIndex, let currentTime, let pausedByUser):
        state.timers.updateTimers(timerIndex: timerIndex) { timerInfo in
            if pausedByUser {
                timerInfo.isPausedByUser = true
            } else {
                timerInfo.isPausedBySystem = true
            }
            timerInfo.value = currentTime
        }
    case .resumeTimer(let timerIndex, let runByUser):
        state.timers.updateTimers(timerIndex: timerIndex) { timerInfo in
            if runByUser {
                timerInfo.isPausedByUser = false
            } else {
                timerInfo.isPausedBySystem = false
            }
        }
    case .stopTimer(let timerIndex):
        state.timers.updateTimers(timerIndex: timerIndex) { timer in
            timer.isPausedByUser = false
            timer.isPausedBySystem = true
            timer.value = 0
        }
    case .timerMaximumChanged(let timerIndex, let maximumTime):
        state.timers.updateTimers(timerIndex: timerIndex) { timer in
            timer.maximum = maximumTime
        }
    case .activateShowmanDecision:
        state.persons.showman.isDeciding = true
    case .activatePlayerDecision(let playerIndex):
        state.persons.players[playerIndex].isDeciding = true
    case .showMainTimer:
        state.showMainTimer = true
    case .clearDecisionsAndMainTimer:
        state.showMainTimer = false
        state.persons.showman.isDeciding = false
        for player in state.persons.players {
            player.isDeciding = false
        }
    case .hintChanged(let hint):
        state.hint = hint
    case .operationError(let error):
        state.chat.messages.append(ChatMessage(sender: "", text: error, isSystem: false))
    case .hostNameChanged(let hostName):
        state.persons.hostName = hostName
    case .themeNameChanged(let themeName):
        state.stage.themeName = themeName
    case .isReadyChanged(let personIndex, let isReady):
        if personIndex == -1 {
            state.persons.showman.isReady = isReady
        } else {
            state.persons.players[personIndex].isReady = isReady
        }
    case .chatMessageAdded(let chatMessage):
        state.chat.messages.append(chatMessage)
    case .roundsNamesChanged(let roundsNames):
        state.roundsNames = roundsNames
    case .chooserChanged(let chooserIndex):
        for (index, player) in state.persons.players.enumerated() {
            player.isChooser = index == chooserIndex
        }
    case .playerInGameChanged(let playerIndex, let inGame):
        state.persons.players[playerIndex].inGame = inGame
    }
    return state
}

