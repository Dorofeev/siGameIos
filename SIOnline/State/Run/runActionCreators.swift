//
//  runActionCreators.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 29.05.2022.
//
import ReSwiftThunk
class RunActionCreators {
    static var timerRef: Int?
    
    static let runChatModeChanged: (ChatMode) -> RunActionTypes = { chatMode in
        RunActionTypes.runChatModeChanged(chatMode: chatMode)
    }
    static let runChatMessageChanged: (String) -> RunActionTypes = { message in
        RunActionTypes.runChatMessageChanged(message: message)
    }
    static let runChatMessageSend: (DataContext) -> (Thunk<State>) = {dataContext in
        Thunk { dispatch, state in
            let text = state()?.run.chat.message ?? ""
            if text.count > 0 {
                dataContext.gameClient.sayAsync(message: text)
            }
            dispatch(runChatMessageChanged(""))
            /* Временно
             dispatch(chatMessageAdded({ sender: state.user.login, text }));
             if (!state.run.chat.isVisible) {
             dispatch(activateChat()); */
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
            var result = dataContext.gameClient.msgAsync(args: [state.run.selection.message, playerIndex])
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
            dataContext.gameClient.msgAsync(args: ["CONFIG", "DELETETABLE", tableIndex])
        }
    }
    static let freeTable: (DataContext) -> (Thunk<State>) = { dataContext in
        Thunk { dispatch, state in
            guard let state = state() else {
                return
            }
            let tableIndex = state.run.selectedTableIndex
            if tableIndex < 0 || tableIndex >= state.run.persons.players.count + 1 {
                return
            }
            let isShowman = tableIndex == 0
            dataContext.gameClient.msgAsync(args: ["CONFIG", "FREE", isShowman ? "showman" : "player", isShowman ? "" : tableIndex - 1])
        }
    }
}

