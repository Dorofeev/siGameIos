//
//  runActionCreators.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 29.05.2022.
//
import ReSwiftThunk
import ReSwift
import PromiseKit
class RunActionCreators {
    static var timerRef: Int?
    
    static let runChatModeChanged: (ChatMode) -> RunActionTypes = { chatMode in
        RunActionTypes.runChatModeChanged(chatMode: chatMode)
    }
    static let runChatMessageChanged: (String) -> RunActionTypes = { message in
        RunActionTypes.runChatMessageChanged(message: message)
    }
    static let runChatMessageSend: (DataContext) -> (Thunk<State>) = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else { return }
            let text = state.run.chat.message
            let login = state.user.login
            if text.count > 0 {
                dataContext.gameClient.sayAsync(message: text)
            }
            
            dispatch(runChatMessageChanged(""))
            
            // Временно
            dispatch(chatMessageAdded(ChatMessage(sender: login, text: text, messageLevel: .information)))
            if (!state.run.chat.isVisible) {
                dispatch(activateChat())
            }
        }
    }
    static let markQuestion: (DataContext) -> (Thunk<State>) = { dataContext in
        Thunk { dispatch, state in
            dataContext.gameClient.msgAsync(args: ["MARK"])
        }
    }
    static let pause: (DataContext) -> (Thunk<State>) = { dataContext in
        Thunk { dispatch, state in
            guard let isGamePaused = state()?.run.stage.isGamePaused else {
                return
            }
            dataContext.gameClient.msgAsync(args: ["PAUSE", isGamePaused ? "-" : "+"])
        }
    }
    static let runShowPersons: () -> RunActionTypes = {
        RunActionTypes.runShowPersons
    }
    static let runHidePersons: () -> RunActionTypes = {
        RunActionTypes.runHidePersons
    }
    static let runShowTables: () -> RunActionTypes = {
        RunActionTypes.runShowTables
    }
    static let runHideTables: () -> RunActionTypes = {
        RunActionTypes.runHideTables
    }
    static let runChatVisibilityChanged: (Bool) -> RunActionTypes = { isOpen in
        RunActionTypes.runChatVisibilityChanged(isOpen: isOpen)
    }
    static let clearDecisions: () -> RunActionTypes = {
        RunActionTypes.clearDecisions
    }
    static let playerSelected: (DataContext, Int) -> (Thunk<State>) = { dataContext, playerIndex in
        Thunk { dispatch , state in
            guard let state = state() else {
                return
            }
            var result = dataContext.gameClient.msgAsync(args: [state.run.selection.message, String(playerIndex)])
            result.done { _ in
                dispatch(clearDecisions())
            }
        }
    }
    static let exitGame: (DataContext) -> (Thunk<State>) = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            // TODO: show progress bar
            var result = dataContext.gameClient.leaveGameAsync()
            result.catch { error in
                Logger.log(message: error.localizedDescription)
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let delegate = windowScene.delegate as? SceneDelegate,
                      let window = delegate.window,
                      let controller = window.rootViewController else {
                    return
                }
                let alert = UIAlertController(title: R.string.localizable.exitError(), message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okAction)
                controller.present(alert, animated: true)
            }
            
            if timerRef != nil {
                GlobalTimers.clearTimeout(id: timerRef!)
                timerRef = nil
            }
            
            if state.ui.previousMainView == MainView.lobby {
              //actionCreators.navigateToLobby(-1)(dispatch, getState, dataContext);
            } else {
              //  dispatch(actionCreators.navigateToWelcome() as any);
            }
        }
    }
    static let chatMessageAdded: (ChatMessage) -> RunActionTypes = { chatMessage in
        RunActionTypes.chatMessageAdded(chatMessage: chatMessage)
    }
    static let lastReplicChanged: (ChatMessage?) -> RunActionTypes = { chatMessage in
        RunActionTypes.lastReplicChanged(chatMessage: chatMessage)
    }
    static let activateChat: () -> RunActionTypes = {
        RunActionTypes.activateChat
    }
    static let showmanReplicChanged: (String) -> RunActionTypes = { replic in
        RunActionTypes.showmanReplicChanged(replic: replic)
    }
    static let playerReplicChanged: (Int, String) -> RunActionTypes = { playerIndex, replic in
        RunActionTypes.playerReplicChanged(playerIndex: playerIndex, replic: replic)
    }
    static let infoChanged: (Persons, PersonInfo, [PlayerInfo]) -> RunActionTypes = { all, showman, players in
        RunActionTypes.infoChanged(all: all, showman: showman, players: players)
    }
    static let chatPersonSelected: (String) -> RunActionTypes = { personName in
        RunActionTypes.chatPersonSelected(personName: personName)
    }
    static let tableSelected: (Int) -> RunActionTypes = { tableIndex in
        RunActionTypes.tableSelected(tableIndex: tableIndex)
    }
    static let operationError: (String) -> RunActionTypes = { error in
        RunActionTypes.operationError(error: error)
    }
    static let addTable: (DataContext) -> (Thunk<State>) = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            if state.run.persons.players.count >= Constants.maxPlayerCount {
                return
            }
            
            dataContext.gameClient.msgAsync(args: ["CONFIG","ADDTABLE"])
        }
    }
    static let deleteTable:  (DataContext) -> (Thunk<State>) = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            let tableIndex = state.run.selectedTableIndex - 1
            if tableIndex < 0 || tableIndex >= state.run.persons.players.count {
                return
            }
            dataContext.gameClient.msgAsync(args: ["CONFIG", "DELETETABLE", String(tableIndex)])
        }
    }
    static let freeTable: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            let tableIndex = state.run.selectedTableIndex
            if tableIndex < 0 || tableIndex >= state.run.persons.players.count + 1 {
                return
            }
            let isShowman = tableIndex == 0
            dataContext.gameClient.msgAsync(args: ["CONFIG", "FREE", isShowman ? "showman" : "player", isShowman ? "" : String(tableIndex - 1)])
        }
    }
    static let setTable: (DataContext, String) -> Thunk<State> = { dataContext, name in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            let tableIndex = state.run.selectedTableIndex
            if tableIndex < 0 || tableIndex >= state.run.persons.players.count + 1 {
                return
            }
            let isShowman = tableIndex == 0
            dataContext.gameClient.msgAsync(args: [
                "CONFIG",
                "SET",
                isShowman ? "showman" : "player",
                isShowman ? "" : String(tableIndex - 1),
                name
            ])
        }
        
    }
    static let changeType: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            let tableIndex = state.run.selectedTableIndex
            if tableIndex < 0 || tableIndex >= state.run.persons.players.count + 1 {
                return
            }
            let isShowman = tableIndex == 0
            dataContext.gameClient.msgAsync(args: ["CONFIG", " CHANGETYPE", isShowman ? "showman" : "player", isShowman ? "" : String(tableIndex - 1)])
        }
    }
    static let kickPerson: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, state in
            guard let state = state(), let personName = state.run.chat.selectedPersonName else {
                return
            }
            dataContext.gameClient.msgAsync(args: ["KICK", personName])
        }
    }
   static let banPerson: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, state in
            guard let state = state(), let personName = state.run.chat.selectedPersonName else {
                return
            }
            dataContext.gameClient.msgAsync(args: ["BAN", personName])
        }
    }
    static let personAvatarChanged: (String, String) -> RunActionTypes = { personName, avatarUri in
        RunActionTypes.personAvatarChanged(personName: personName, avatarUri: avatarUri)
    }
    static let gameStarted: () -> RunActionTypes = {
        RunActionTypes.gameStarted
    }
    static let stageChanged: (String, Int) -> RunActionTypes = { stageName, roundIndex in
        RunActionTypes.stageChanged(stageName: stageName, roundIndex: roundIndex)
    }
    static let playersStateCleared: () -> RunActionTypes = {
        RunActionTypes.playersStateCleared
    }
    static let gameStateCleared: () -> RunActionTypes = {
        RunActionTypes.gameStateCleared
    }
    static let sumsChanged: ([Int]) -> RunActionTypes = { sums in
        RunActionTypes.sumsChanged(sums: sums)
    }
    static let afterQuestionStateChanged: (Bool) -> RunActionTypes = { isAfterQuestion in
        RunActionTypes.afterQuestionStateChanged(isAfterQuestion: isAfterQuestion)
    }
    static let currentPriceChanged: (Int) -> RunActionTypes = { currentPrice in
        RunActionTypes.currentPriceChanged(currentPrice: currentPrice)
    }
    static let personAdded: (Account) -> RunActionTypes = { person in
        RunActionTypes.personAdded(person: person)
    }
    static let personRemoved: (String) -> RunActionTypes = { name in
        RunActionTypes.personRemoved(name: name)
    }
    static let showmanChanged: (String, Bool?, Bool?) -> RunActionTypes = { name, isHuman, isReady in
        RunActionTypes.showmanChanged(name: name, isHuman: isHuman, isReady: isReady)
    }
    static let playerAdded: () -> RunActionTypes = {
        RunActionTypes.playerAdded
    }
    static let playerChanged: (Int, String, Bool?, Bool?) -> RunActionTypes = { index, name, isHuman, isReady in
        RunActionTypes.playerChanged(index: index, name: name, isHuman: isHuman, isReady: isReady)
    }
    static let playerDeleted: (Int) -> RunActionTypes = { index in
        RunActionTypes.playerDeleted(index: index)
    }
    static let playersSwap: (Int, Int) -> RunActionTypes = { index1, index2 in
        RunActionTypes.playersSwap(index1: index1, index2: index2)
    }
    static let roleChanged: (Role) -> RunActionTypes = { role in
        RunActionTypes.roleChanged(role: role)
    }
    static let playerStateChanged: (Int, PlayerStates) -> RunActionTypes = { index, state in
        RunActionTypes.playerStateChanged(index: index, state: state)
    }
    static let playerLostStateDropped: (Int) -> RunActionTypes = { index in
        RunActionTypes.playerLostStateDropped(index: index)
    }
    static let isPausedChanged: (Bool) -> RunActionTypes = { isPaused in
        RunActionTypes.isPausedChanged(isPaused: isPaused)
    }
    static let playerStakeChanged: (Int, Int) -> RunActionTypes = { index, stake in
        RunActionTypes.playerStakeChanged(index: index, stake: stake)
    }
    static let decisionNeededChanged: (Bool) -> RunActionTypes = { decisionNeeded in
        RunActionTypes.decisionNeededChanged(decisionNeeded: decisionNeeded)
    }
    static let selectQuestion: (DataContext, Int, Int) -> Thunk<State> = { dataContext, themeIndex, questionIndex in
        Thunk { dispatch, state in
            guard let state = state(), state.run.table.isSelectable, state.run.table.roundInfo.count > themeIndex else {
                return
            }
            
            let theme = state.run.table.roundInfo[themeIndex]
            let question = theme.questions[questionIndex]
            if question > -1 {
                let result = dataContext.gameClient.msgAsync(args: ["CHOICE", String(themeIndex), String(questionIndex)])
                result.done { _ in
                    dispatch(TableActionCreators.isSelectableChanged(false))
                    dispatch(decisionNeededChanged(false))
                }
            }
        }
    }
    static let selectTheme: (DataContext, Int) -> Thunk<State> = { dataContext, themeIndex in
        Thunk { dispatch, state in
            guard let state = state(), state.run.table.isSelectable, state.run.table.roundInfo.count > themeIndex else {
                return
            }
            let theme = state.run.table.roundInfo[themeIndex]
            let result = dataContext.gameClient.msgAsync(args: ["DELETE", String(themeIndex)])
            result.done { _ in
                dispatch(TableActionCreators.isSelectableChanged(false))
                dispatch(decisionNeededChanged(false))
            }
        }
    }
    static let isGameButtonEnabledChanged: (Bool) -> RunActionTypes = { isGameButtonEnabled in
        RunActionTypes.isGameButtonEnabledChanged(isGameButtonEnabled: isGameButtonEnabled)
    }
    static let pressGameButton: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            let result = dataContext.gameClient.msgAsync(args: ["I"])
            result.done { _ in
                dispatch(isGameButtonEnabledChanged(false))
                GlobalTimers.setTimeout(delay: 3) {
                    dispatch(isGameButtonEnabledChanged(true))
                }
            }
        }
    }
    static let apellate: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { _, _ in
            dataContext.gameClient.msgAsync(args: ["APELLATE", "+"])
        }
    }
    static let disagree: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { _, _ in
            dataContext.gameClient.msgAsync(args: ["APELLATE", "-"])
        }
    }
    static let isAnswering: () -> RunActionTypes = {
        RunActionTypes.isAnswering
    }
    static let onAnswerChanged: (String) -> RunActionTypes = { answer in
        RunActionTypes.answerChanged(answer: answer)
    }
    static let sendAnswer: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            let result = dataContext.gameClient.msgAsync(args: ["ANSWER", state.run.answer ?? ""])
            result.done { _ in
                dispatch(clearDecisions())
            }
        }
    }
    static let validate: (String, String, [String], [String], String, String)
    -> RunActionTypes = { name, answer, rightAnswers, wrongAnswers, header, message in
        RunActionTypes.validateAction(
            name: name,
            answer: answer,
            rightAnswers: rightAnswers,
            wrongAnswers: wrongAnswers,
            header: header,
            message: message
        )
    }
    static let approveAnswer: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, _ in
            let result = dataContext.gameClient.msgAsync(args: ["ISRIGHT", "+"])
            result.done { _ in
                dispatch(clearDecisions())
            }
        }
    }
    static let rejectAnswer: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, _ in
            let result = dataContext.gameClient.msgAsync(args: ["ISRIGHT", "-"])
            result.done { _ in
                dispatch(clearDecisions())
            }
        }
    }
    static let setStakes: ([StakeTypes: Bool], Int, Int, Int, Int, String, Bool)
    -> RunActionTypes = { allowedStakeTypes, minimum, maximum, stake, step, message, areSimple in
        RunActionTypes.setStakes(
            allowedStakeTypes: allowedStakeTypes,
            minimum: minimum,
            maximum: maximum,
            stake: stake,
            step: step,
            message: message,
            areSimple: areSimple
        )
    }
    static let stakeChanged: (Int) -> RunActionTypes = { stake in
        RunActionTypes.stakeChanged(stake: stake)
    }
    static let sendNominal: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, _ in
            let result = dataContext.gameClient.msgAsync(args: ["STAKE", "0"])
            result.done { _ in
                dispatch(clearDecisions())
            }
        }
    }
    static let sendStake: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            var result: Promise<Bool>
            if state.run.stakes.message == "STAKE" {
                result = dataContext.gameClient.msgAsync(args: ["STAKE", "1", String(state.run.stakes.stake)])
            } else {
                result = dataContext.gameClient.msgAsync(args: [state.run.stakes.message, String(state.run.stakes.stake)])
            }
            result.done { _ in
                dispatch(clearDecisions())
            }
        }
    }
    static let sendPass: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, _ in
            let result = dataContext.gameClient.msgAsync(args: ["STAKE", "2"])
            result.done { _ in
                dispatch(clearDecisions())
            }
        }
    }
    static let sendAllIn: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, _ in
            let result = dataContext.gameClient.msgAsync(args: ["STAKE", "3"])
            result.done { _ in
                dispatch(clearDecisions())
            }
        }
    }
    static let selectionEnabled: ([Int], String) -> RunActionTypes = { allowedIndices, message in
        RunActionTypes.selectionEnabled(allowedIndices: allowedIndices, message: message)
    }
    static let showLeftSeconds: (Int, @escaping DispatchFunction) -> Void = { leftSecond, dispatch in
        var leftSecondString = String(leftSecond % 60)
        if leftSecondString.count < 2 {
            leftSecondString = "0\(leftSecond)"
        }
        let replic = "\(R.string.localizable.theGameWillStartIn()) 00:00:\(leftSecondString) \(R.string.localizable.orByFilling())"
        dispatch(showmanReplicChanged(replic))
        if leftSecond > 0 {
            timerRef = GlobalTimers.setTimeout(delay: 1, block: {
                showLeftSeconds(leftSecond - 1, dispatch)
            })
        }
    }
    static let onMediaEnded: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, _ in
            dataContext.gameClient.msgAsync(args: ["ATOM"])
        }
    }
    static let areSumsEditableChanged: (Bool) -> RunActionTypes = { areSumsEditable in
        RunActionTypes.areSumsEditableChanged(areSumsEditable: areSumsEditable)
    }
    static let changePlayerSum: (DataContext, Int, Int) -> Thunk<State> = { dataContext, playerIndex, sum in
        Thunk { dispatch, _ in
            dataContext.gameClient.msgAsync(args: ["CHANGE", String(playerIndex + 1), String(sum)]) // playerIndex here starts with 1
        }
    }
    static let readingSpeedChanged: (Int) -> RunActionTypes = { readingSpeed in
        RunActionTypes.readingSpeedChanged(readingSpeed: readingSpeed)
    }
    static let runTimer: (Int, Int, Bool) -> RunActionTypes = { timerIndex, maximumTime, runByUser in
        RunActionTypes.runTimer(timerIndex: timerIndex, maximumTime: maximumTime, runByUser: runByUser)
    }
    static let pauseTimer: (Int, Int, Bool) -> RunActionTypes = { timerIndex, currentTime, pauseByUser in
        RunActionTypes.pauseTimer(timerIndex: timerIndex, currentTime: currentTime, pausedByUser: pauseByUser)
    }
    static let resumeTimer: (Int, Bool) -> RunActionTypes = { timerIndex, runByUser in
        RunActionTypes.resumeTimer(timerIndex: timerIndex, runByUser: runByUser)
    }
    static let stopTimer: (Int) -> RunActionTypes = { timerIndex in
        RunActionTypes.stopTimer(timerIndex: timerIndex)
    }
    static let timerMaximumChanged: (Int, Int) -> RunActionTypes = { timerIndex, maximumTime in
        RunActionTypes.timerMaximumChanged(timerIndex: timerIndex, maximumTime: maximumTime)
    }
    static let activateShowmanDecision: () -> RunActionTypes = {
        RunActionTypes.activateShowmanDecision
    }
    static let activatePlayerDecision: (Int) -> RunActionTypes = { playerIndex in
        RunActionTypes.activatePlayerDecision(playerIndex: playerIndex)
    }
    static let showMainTimer: () -> RunActionTypes = {
        RunActionTypes.showMainTimer
    }
    static let clearDecisionsAndMainTimer: () -> RunActionTypes = {
        RunActionTypes.clearDecisionsAndMainTimer
    }
    static let hintChanged: (String?) -> RunActionTypes = { hint in
        RunActionTypes.hintChanged(hint: hint)
    }
    static let startGame: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, _ in
            dataContext.gameClient.msgAsync(args: ["START"])
        }
    }
    static let ready: (DataContext, Bool) -> Thunk<State> = { dataContext, isReady in
        Thunk { dispatch, _ in
            dataContext.gameClient.msgAsync(args: ["READY", isReady ? "+" : "-"])
        }
    }
    static let roundsNamesChanged: ([String]) -> RunActionTypes = { roundNames in
        RunActionTypes.roundsNamesChanged(roundsNames: roundNames)
    }
    static let hostNameChanged: (String?) -> RunActionTypes = { hostName in
        RunActionTypes.hostNameChanged(hostName: hostName)
    }
    static let themeNameChanged: (String) -> RunActionTypes = { themeName in
        RunActionTypes.themeNameChanged(themeName: themeName)
    }
    static let updateCaption: (DataContext, String) -> Thunk<State> = { dataContext, questionCaption in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            let themeName = state.run.stage.themeName
            dispatch(TableActionCreators.captionChanged("\(themeName), \(questionCaption)"))
        }
    }
    static let moveNext: (DataContext) -> Thunk<State> = { dataContext in
        Thunk { dispatch, _ in
            dataContext.gameClient.msgAsync(args: ["MOVE", "1"])
        }
    }
    static let navigateToRound: (DataContext, Int) -> Thunk<State> = { dataContext, roundIndex in
        Thunk { dispatch, _ in
            dataContext.gameClient.msgAsync(args: ["MOVE", "3", String(roundIndex)])
        }
    }
    static let isReadyChanged: (Int, Bool) -> RunActionTypes = { personIndex, isReady in
        RunActionTypes.isReadyChanged(personIndex: personIndex, isReady: isReady)
    }
    static let chooserChanged: (Int) -> RunActionTypes = { chooserIndex in
        RunActionTypes.chooserChanged(chooserIndex: chooserIndex)
    }
    static let playerInGameChanged: (Int, Bool) -> RunActionTypes = { playerIndex, inGame in
        RunActionTypes.playerInGameChanged(playerIndex: playerIndex, inGame: inGame)
    }
}
