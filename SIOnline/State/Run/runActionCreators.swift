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
}
