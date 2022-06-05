//
//  MessageProcessor.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 05.06.2022.
//

import ReSwift
import ReSwiftThunk

class MessageProcessor {
    static var lastReplicLock: Int = 0
    
    static func messageProcessor(dispatch: DispatchFunction, message: ChatMessage) {
        if message.isSystem {
            dispatch(processSystemMessage(message))
            return
        }
        
        dispatch(userMessageReceived(message))
    }
    
    static let processSystemMessage: (ChatMessage) -> Thunk<State> = { message in
        Thunk { dispatch, state in
            guard let state = state() else { return }
            let role = state.run.role
            let args = message.text.components(separatedBy: "\n")
            
            // TODO: - not yet implemented
            // viewerHandler(dispatch, state, dataContext, args);
            
            switch role {
            case .Player:
                // TODO: - not yet implemented
                //playerHandler(dispatch, state, dataContext, args);
                break
            case .Showman:
                // TODO: - not yet implemented
                // showmanHandler(dispatch, state, dataContext, args);
                break
            default:
                break
            }
        }
    }
    
    static let userMessageReceived: (ChatMessage) -> Thunk<State> = { message in
        Thunk { dispatch, state in
            guard let state = state() else { return }
            
            if message.sender == state.user.login {
                return
            }
            
            let replic: ChatMessage = ChatMessage(sender: message.sender, text: message.text, isSystem: false)
            // TODO: - not yet implemented
            //  dispatch(runActionCreators.chatMessageAdded(replic));
            
            if !state.run.chat.isVisible && state.ui.windowWidth < 800 {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.lastReplicChanged(replic));
                
                if lastReplicLock != 0 {
                    // TODO: - not yet implemented
                    //window.clearTimeout(lastReplicLock);
                }
                
                // TODO: - not yet implemented
                // lastReplicLock = window.setTimeout(
                //            () => {
                //                dispatch(runActionCreators.lastReplicChanged(null));
                //            },
                //            3000
                //        );
            }
        }
    }
    
    static func onReady(personName: String, isReady: Bool, dispatch: DispatchFunction, state: State) {
        let personIndex: Int
        if personName == state.run.persons.showman.name {
            personIndex = -1
        } else {
            personIndex = state.run.persons.players.firstIndex(where: { $0.name == personName }) ?? -1
            if personIndex == -1 { return }
        }
        
        // TODO: - not yet implemented
        //dispatch(runActionCreators.isReadyChanged(personIndex, isReady));
    }
    
    static let viewerHandler: (DispatchFunction, State, DataContext, [String]) -> Void = { dispatch, state, dataContext, args in
        switch args[0] {
        case "ADS" where args.count > 1:
            let adsMessage = args[1]
            // TODO: show ad on screen
        case "ATOM":
            switch args[1] {
            case "text" where args.count > 2, "partial" where args.count > 2:
                let text = ""
                for iterator in (2..<args.count) {
                    
                }
            default:
                break
            }
        default:
            break
        }
    }
}
