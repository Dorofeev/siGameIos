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
    
    static func messageProcessor(dispatch: DispatchFunction, message: ChatMessage, dataContext: DataContext) {
        if message.isSystem {
            dispatch(processSystemMessage(message, dataContext))
            return
        }
        
        dispatch(userMessageReceived(message))
    }
    
    static let processSystemMessage: (ChatMessage, DataContext) -> Thunk<State> = { message, dataContext in
        Thunk { dispatch, state in
            guard let state = state() else { return }
            let role = state.run.role
            let args = message.text.components(separatedBy: "\n")
            
            viewerHandler(dispatch, state, dataContext, args)
            
            switch role {
            case .Player:
                playerHandler(dispatch, state, dataContext, args)
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
        let firstArg = args.first ?? ""
        let secondArg = args.count > 1 ? args[0] : ""
        switch firstArg {
        case "ADS" where args.count > 1:
            let adsMessage = secondArg
            // TODO: show ad on screen
        case "ATOM":
            switch secondArg {
            case "text", "partial":
                var text = ""
                for value in args.dropFirst(2)  {
                    if text.count > 0 {
                        text += "\n"
                    }
                    text += value
                }
                if secondArg == "text" {
                    dispatch(TableActionCreators.showText(text, true))
                } else {
                    dispatch(TableActionCreators.appendPartialText(text))
                }
            case "image":
                // TODO: - not yet implemented
//                const uri = preprocessServerUri(args[3], dataContext);
//                dispatch(tableActionCreators.showImage(uri));
                break
            case "voice":
                // TODO: - not yet implemented
//                const uri = preprocessServerUri(args[3], dataContext);
//                dispatch(tableActionCreators.showAudio(uri));
                break
            case "video":
                // TODO: - not yet implemented
//                const uri = preprocessServerUri(args[3], dataContext);
//                dispatch(tableActionCreators.showVideo(uri));
                break
            default:
                break
            }
        case "ATOM_SECOND":
            // TODO: process
            break
        case "BUTTON_BLOCKING_TIME":
            // TODO: process
            break
        case "CHOICE":
            guard args.count > 2,
                  let themeIndex = Int(secondArg),
                  let questIndex = Int(args[2]) else { break }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.playersStateCleared());
            // dispatch(runActionCreators.afterQuestionStateChanged(false));
            
            guard let themeInfo = state.run.table.roundInfo.getSafe(themeIndex),
                  let quest = themeInfo.questions.getSafe(questIndex) else {
                break
            }
            
            // TODO: - not yet implemented
            //dispatch(runActionCreators.currentPriceChanged(quest));
            
            dispatch(TableActionCreators.captionChanged("\(themeInfo.name), \(quest)"))
            dispatch(TableActionCreators.blinkQuestion(themeIndex, questIndex))
            
            // TODO: - not yet implemented
            // setTimeout(
            //     dispatch(tableActionCreators.removeQuestion(themeIndex, questIndex));
            //     5000
            // )
        case "CONFIG":
            // TODO: - not yet implemented
            // config(dispatch, state, ...args);
            break
        case "CONNECTED":
            // TODO: - not yet implemented
            // connected(dispatch, state, ...args);
            break
        case "DISCONNECTED":
            // TODO: - not yet implemented
            // disconnected(dispatch, state, ...args);
            break
        case "ENDTRY":
            dispatch(TableActionCreators.canPressChanged(false))
            if let index = Int(secondArg), index > -1, index < state.run.persons.players.count {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.playerStateChanged(index, PlayerStates.Press));
            } else if secondArg == "A" {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.stopTimer(1));
            }
        case "FALSESTART":
            // TODO: process
            break
        case "FINALROUND":
            // TODO: process
            break;
        case "FINALTHINK":
            // TODO: process
            break;
        case "GAMETHEMES":
            let gameThemes = Array(args.dropFirst())
            dispatch(TableActionCreators.showGameThemes(gameThemes))
        case "HOSTNAME" where args.count > 1:
            // TODO: - not yet implemented
            // dispatch(runActionCreators.hostNameChanged(secondArg));
            if args.count > 2 {
                let changeSource = args[2].count > 0 ? args[2] : R.string.localizable.byGame()
                
                // TODO: - not yet implemented
                //dispatch(runActionCreators.chatMessageAdded({ sender: '', text: stringFormat(localization.hostNameChanged, changeSource, args[1])
            }
        case "INFO2":
            // TODO: - not yet implemented
            // info(dispatch, ...args);
            break
        case "OUT":
            guard let themeIndex = Int(secondArg), let themeInfo = state.run.table.roundInfo.getSafe(themeIndex) else { break }
            dispatch(TableActionCreators.blinkTheme(themeIndex))
            
            // TODO: - not yet implemented
            // setTimeout({ dispatch(tableActionCreators.removeTheme(themeIndex)); }, 600)
        case "PACKAGELOGO":
            // TODO: process
            break
        case "PASS":
            // TODO: process
            break
        case "PAUSE":
            let isPaused = secondArg == "+"
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.isPausedChanged(isPaused));
            
            if args.count > 4 {
                if isPaused {
                    
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.pauseTimer(0, args[2], true));
                    // dispatch(runActionCreators.pauseTimer(1, args[3], true));
                    // dispatch(runActionCreators.pauseTimer(2, args[4], true));
                    
                } else {
                    
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.resumeTimer(0, true));
                    // dispatch(runActionCreators.resumeTimer(1, true));
                    // dispatch(runActionCreators.resumeTimer(2, true));
                    
                }
            }
        case "PERSON":
            let isRight = secondArg == "="
            guard let stringIndex = args.getSafe(2),
                  let index = Int(stringIndex),
                  index > -1,
                  index < state.run.persons.players.count else { break }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.playerStateChanged(index, isRight ? PlayerStates.Right : PlayerStates.Wrong));
        case "PERSONAPELLATED":
            // TODO: process
            break
        case "PERSONFINALANSWER":
            // TODO: process
            break
        case "PERSONFINALSTAKE":
            // TODO: process
            break
        case "PERSONSTAKE":
            guard let playerIndex = Int(secondArg),
                  let player = state.run.persons.players.getSafe(playerIndex),
                  let stakeType = args.getSafe(2)?.toInt() else { break }
            
            var stake = 0
            switch stakeType {
            case 0:
                stake = state.run.stage.currentPrice
            case 1:
                stake = args.getSafe(3)?.toInt() ?? 0
            case 2:
                break
            case 3:
                stake = player.sum
            default:
                break
            }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.playerStakeChanged(playerIndex, stake));
        case "PICTURE":
            
            // TODO: - not yet implemented
            // const uri = preprocessServerUri(args[2], dataContext);
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.personAvatarChanged(personName, uri));
            break
        case "QTYPE":
            switch secondArg {
            case "auction":
                dispatch(TableActionCreators.showSpecial(text: R.string.localizable.questionTypeStake(), activeThemeIndex: state.run.table.activeThemeIndex))
            case "cat", "bagcat":
                dispatch(TableActionCreators.showSpecial(text: R.string.localizable.questionTypeSecret()))
            case "sponsored":
                dispatch(TableActionCreators.showSpecial(text: R.string.localizable.questionTypeNoRisk()))
            default:
                break
            }
        case "QUESTION" where args.count > 1:
            // TODO: - not yet implemented
            //dispatch(runActionCreators.playersStateCleared());
            
            dispatch(TableActionCreators.showText(secondArg, false))
//            dispatch(runActionCreators.playersStateCleared());
//            dispatch(tableActionCreators.showText(args[1], false));
//            dispatch(runActionCreators.afterQuestionStateChanged(false));
//            dispatch(runActionCreators.updateCaption(args[1]));
            
        case "QUESTIONCAPTION" where args.count > 1:
            dispatch(TableActionCreators.captionChanged(secondArg))
        case "READINGSPEED" where args.count > 1:
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.readingSpeedChanged(parseInt(args[1], 10)));
            
            break
        case "READY" where args.count > 1:
            let isReady = args.count < 3 || args.getSafe(2) == "+"
            onReady(personName: secondArg, isReady: isReady, dispatch: dispatch, state: state)
        case "REPLIC" where args.count > 2:
            
            // TODO: - not yet implemented
            // onReplic(dispatch, state, args);
            
            break
        case "RESUME":
            dispatch(TableActionCreators.resumeMedia())
        case "RIGHTANSWER":
            if let answer = args.getSafe(2) {
                dispatch(TableActionCreators.showAnswer(answer))
            }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.afterQuestionStateChanged(true));
            
            dispatch(TableActionCreators.captionChanged(""))
        case "ROUNDSNAMES":
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.roundsNamesChanged(args.slice(1)));
            
            break
        case "ROUNDTHEMES":
            let printThemes = secondArg == "+"
            
            let roundThemes: [ThemeInfo] = args.dropFirst(2).map { name in
                ThemeInfo(name: name, questions: [])
            }
            
            dispatch(TableActionCreators.showRoundThemes(roundThemes, state.run.stage.name == "Final", printThemes))
        case "SETCHOOSER":
            // TODO: process
            break
        case "SHOWTABLO":
            dispatch(TableActionCreators.showRoundTable())
        case "STAGE":
            let roundIndex = args.getSafe(3)?.toInt() ?? -1
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.stageChanged(stage, roundIndex));
            
            if secondArg != "Before" {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.gameStarted());
            }
            
            if secondArg == "Round" || secondArg == "Final" {
                dispatch(TableActionCreators.showText(secondArg, false))
                
                // TODO: - not yet implemented
                // dispatch(runActionCreators.playersStateCleared());
            } else if secondArg == "After" {
                dispatch(TableActionCreators.showLogo())
            }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.gameStateCleared());
        case "STOP":
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.stopTimer(0));
            // dispatch(runActionCreators.stopTimer(1));
            // dispatch(runActionCreators.stopTimer(2));
            
            dispatch(TableActionCreators.showLogo())
        case "SUMS":
            let max = min(args.count - 1, state.run.persons.players.count)
            var sums: [Int] = []
            for index in 1...max {
                if let value = args.getSafe(index)?.toInt() {
                    sums.append(value)
                }
            }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.sumsChanged(sums));
        case "TABLO2":
            let roundInfo = state.run.table.roundInfo
            let areQuestionsFilled = roundInfo.contains(where: { $0.questions.count > 0 })
            
            if areQuestionsFilled {
                break
            }
            
            var index = 1
            var newRoundInfo: [ThemeInfo] = []
            var maxQuestionsInTheme = 0
            
            for info in roundInfo {
                if index == args.count {
                    break
                }
                
                var questions: [Int] = []
                
                while index < args.count && args[index].count > 0 { // пустой параметр разделяет темы
                    if let question = args.getSafe(index)?.toInt() {
                        questions.append(question)
                    }
                    index += 1
                }
                
                maxQuestionsInTheme = max(maxQuestionsInTheme, questions.count)
                let newTheme = ThemeInfo(name: info.name, questions: questions)
                newRoundInfo.append(newTheme)
                index += 1
            }
            
            // Выровняем число вопросов
            for info in newRoundInfo {
                let questionsCount = maxQuestionsInTheme - info.questions.count
                if questionsCount <= 0 { continue }
                
                for _ in 0..<questionsCount {
                    info.questions.append(-1)
                }
            }
            
            dispatch(TableActionCreators.showRoundThemes(newRoundInfo, state.run.stage.name == "Final", false))
        case "TEXTSHAPE":
            var text = ""
            
            for arg in args.dropFirst() {
                if text.count > 0 {
                    text.append("\n")
                }
                
                text += arg
            }
            
            dispatch(TableActionCreators.showPartialText(text))
        case "TIMEOUT":
            // TODO: process
            break
        case "TIMER":
            // Special case for automatic game
            if !state.run.stage.isGameStarted && state.game.isAutomatic && args.count == 5 && args[1] == "2" && args[2] == "GO" && args[4] == "-2" {
                let leftSeconds = (args[3].toInt() ?? 0) / 10
             
                // TODO: - not yet implemented
                // runActionCreators.showLeftSeconds(leftSeconds, dispatch);
            } else if args.count > 2 {
                let timerIndex = args[1].toInt() ?? 0
                let timerCommand = args[2]
                let timerArgument = args.getSafe(3)?.toInt() ?? 0
                let timerPersonIndex = args.getSafe(4)?.toInt()
                
                switch timerCommand {
                case "GO":
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.runTimer(timerIndex, timerArgument, false));
                    
                    if let timerPersonIndex = timerPersonIndex, timerIndex == 2 {
                        if timerPersonIndex == -1 {
                            // TODO: - not yet implemented
                            // dispatch(runActionCreators.activateShowmanDecision());
                        } else if timerPersonIndex == -2 {
                            // TODO: - not yet implemented
                            // dispatch(runActionCreators.showMainTimer());
                        } else if timerPersonIndex > -1 && timerPersonIndex < state.run.persons.players.count {
                            // TODO: - not yet implemented
                            // dispatch(runActionCreators.activatePlayerDecision(timerPersonIndex));
                        }
                        
                    }
                case "STOP":
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.stopTimer(timerIndex));
                    
                    if timerIndex == 2 {
                        // TODO: - not yet implemented
                        // dispatch(runActionCreators.clearDecisionsAndMainTimer());
                    }
                case "PAUSE":
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.pauseTimer(timerIndex, timerArgument, false));
                    break
                case "USER_PAUSE":
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.pauseTimer(timerIndex, timerArgument, true));
                    break
                case "RESUME":
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.resumeTimer(timerIndex, false));
                    break
                case "USER_RESUME":
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.resumeTimer(timerIndex, true));
                    break
                case "MAXTIME":
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.timerMaximumChanged(timerIndex, timerArgument));
                    break
                default:
                    break
                }
            }
        case "THEME" where args.count > 1:
            // TODO: - not yet implemented
            // dispatch(runActionCreators.playersStateCleared());
            // dispatch(runActionCreators.showmanReplicChanged(''));
            
            dispatch(TableActionCreators.showText("\(R.string.localizable.theme): \(secondArg)", false))
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.afterQuestionStateChanged(false));
            // dispatch(runActionCreators.themeNameChanged(args[1]));
        case "TRY":
            dispatch(TableActionCreators.canPressChanged(true))
        case "WINNER":
            // TODO: process
            break
        case "WRONGTRY":
            guard let index = secondArg.toInt() else { return }
            let players = state.run.persons.players
            if index > -1 && index < players.count {
                let player = players[index]
                if player.state == .none {
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.playerStateChanged(index, PlayerStates.Lost));
                    // setTimeout( () => { dispatch(runActionCreators.playerLostStateDropped(index)); }, 200 )
                }
            }
        default:
            break
        }
    }
    
    static let playerHandler: (DispatchFunction, State, DataContext, [String]) -> Void = { dispatch, state, dataContext, args in
        guard !args.isEmpty else { return }
        switch args[0] {
        case "ANSWER":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.isAnswering());
            break
        case "CANCEL":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.clearDecisions());
            break
        case "CAT":
            // TODO: - not yet implemented
            // const indices = getIndices(args);
            // dispatch(runActionCreators.selectionEnabled(indices, 'CAT'));
            break
        case "CATCOST":
            let allowedStakeTypes = [StakeTypes.nominal: false, .sum: true, .pass: false, .allIn: false]
            
            guard let minimum = args.getSafe(1)?.toInt(),
                  let maximum = args.getSafe(2)?.toInt(),
                  let step = args.getSafe(3)?.toInt() else { return }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.setStakes(allowedStakeTypes, minimum, maximum, minimum, step, 'CATCOST', true));
            // dispatch(runActionCreators.decisionNeededChanged(true));
        case "CHOOSE":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.decisionNeededChanged(true));
            
            dispatch(TableActionCreators.isSelectableChanged(true))
        case "FINALSTAKE":
            // TODO: - not yet implemented
            // const me = getMe(state);
            // if (!me) { break; }
            
            let allowedStakeTypes = [StakeTypes.nominal: false, .sum: true, .pass: false, .allIn: false]
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.setStakes(allowedStakeTypes, 1, me.sum, 1, 1, 'FINALSTAKE', true));
            // dispatch(runActionCreators.decisionNeededChanged(true));
        case "REPORT":
            // TODO: process
            break
        case "STAKE":
            let allowedStakeTypes = [
                StakeTypes.nominal: args.getSafe(1) == "+",
                .sum: args.getSafe(2) == "+",
                .pass: args.getSafe(3) == "+",
                .allIn: args.getSafe(4) == "+"
            ]
            
            guard let minimum = args.getSafe(5) else { return }
            
            // TODO: - not yet implemented
            // const me = getMe(state);
            // if (!me) { return; }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.setStakes(allowedStakeTypes, minimum, me.sum, minimum, 100, 'STAKE', false));
            // dispatch(runActionCreators.decisionNeededChanged(true));
        case "VALIDATION":
            // TODO: - not yet implemented
            // startValidation(dispatch, localization.apellation, args);
            break
        default:
            break
        }
    }
}
