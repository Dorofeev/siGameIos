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
                showmanHandler(dispatch, state, dataContext, args)
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
                let uri = preprocessServerUri(uri: args[3], dataContext: dataContext)
                dispatch(TableActionCreators.showImage(uri))
            case "voice":
                let uri = preprocessServerUri(uri: args[3], dataContext: dataContext)
                dispatch(TableActionCreators.showAudio(uri))
            case "video":
                let uri = preprocessServerUri(uri: args[3], dataContext: dataContext)
                dispatch(TableActionCreators.showVideo(uri))
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
            config(dispatch: dispatch, state: state, args: args)
        case "CONNECTED":
            connected(dispatch: dispatch, state: state, args: args)
        case "DISCONNECTED":
            disconnected(dispatch: dispatch, state: state, args: args)
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
            info(dispatch: dispatch, args: args)
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
            let uri = preprocessServerUri(uri: args[2], dataContext: dataContext)
            
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
            onReplic(dispatch: dispatch, state: state, args: args)
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
            let indices = getIndices(args: args)
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.selectionEnabled(indices, 'CAT'));
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
            guard let me = getMe(state: state) else { break }
            
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
            
            guard let me = getMe(state: state) else { return }
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.setStakes(allowedStakeTypes, minimum, me.sum, minimum, 100, 'STAKE', false));
            // dispatch(runActionCreators.decisionNeededChanged(true));
        case "VALIDATION":
            startValidation(dispatch: dispatch, title: R.string.localizable.apellation(), args: args)
        default:
            break
        }
    }
    
    static let showmanHandler: (DispatchFunction, State, DataContext, [String]) -> Void = { dispatch, state, dataContext, args in
        guard !args.isEmpty else { return }
        
        switch args[0] {
        case "CANCEL":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.clearDecisions());
            break
        case "FIRST":
            let indices = getIndices(args: args)
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.selectionEnabled(indices, 'FIRST'));
            // dispatch(runActionCreators.showmanReplicChanged(localization.selectFirstPlayer));
        case "FIRSTDELETE":
            let indices = getIndices(args: args)
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.selectionEnabled(indices, 'NEXTDELETE'));
            // dispatch(runActionCreators.showmanReplicChanged(localization.selectThemeDeleter));
        case "FIRSTSTAKE":
            let indices = getIndices(args: args)
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.selectionEnabled(indices, 'NEXT'));
            // dispatch(runActionCreators.showmanReplicChanged(localization.selectStaker));
        case "HINT" where args.count > 1:
            // TODO: - not yet implemented
            // dispatch(runActionCreators.hintChanged(`${localization.rightAnswer}: ${args[1]}`));
            break
        case "RIGHTANSWER":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.hintChanged(null));
            break
        case "STAGE":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.decisionNeededChanged(false));
            // dispatch(runActionCreators.hintChanged(null));
            break
        case "VALIDATION":
            startValidation(dispatch: dispatch, title: R.string.localizable.answerChecking(), args: args)
        default:
            break
        }
    }
    
    static func startValidation(dispatch: DispatchFunction, title: String, args: [String]) {
        if args.count < 5 { return }
        
        let name = args[1]
        let answer = args[2]
        let isVoteForTheRightAnswer = args[3] == "+" // Not used
        let rightAnswersCount = min(args.count - 5, args[4].toInt() ?? 999)
        var right: [String] = []
        
        for index in 0..<rightAnswersCount {
            right.append(args[5 + index])
        }
        
        var wrong: [String] = []
        
        for arg in args.dropFirst(5 + rightAnswersCount) {
            wrong.append(arg)
        }
        
        let validationMesssage = "\(R.string.localizable.playersAnswer()) \(name) \"\(answer)\". \(R.string.localizable.validateAnswer())"
        
        // TODO: - not yet implemented
        // dispatch(runActionCreators.validate(name, answer, right, wrong, title, validationMesssage));
    }
    
    static func getIndices(args: [String]) -> [Int] {
        var indices: [Int] = []
        for (index, arg) in args.dropFirst().enumerated() where arg == "+" {
            indices.append(index)
        }
        
        return indices
    }
    
    static func info(dispatch: DispatchFunction, args: [String]) {
        guard let playersCount = args.getSafe(1)?.toInt() else {
            return
        }
        
        let viewersCount = (args.count - 2) / 5 - 1 - playersCount
        var pIndex = 2
        
        var name = args[pIndex]
        pIndex += 1
        var isMale = args[pIndex] == "+"
        pIndex += 1
        var isConnected = args[pIndex] == "+"
        pIndex += 1
        var isHuman = args[pIndex] == "+"
        pIndex += 1
        var isReady = args[pIndex] == "+"
        pIndex += 1

        var all: Persons = [:]
        let showman = PersonInfo(name: name, isReady: isReady, replic: nil, isDeciding: false, isHuman: isHuman)
        
        if isConnected {
            all[name] = Account(name: name, sex: isMale ? .male : .female, isHuman: isHuman, avatar: nil)
        }
        
        var players: [PlayerInfo] = []
        
        for _ in 0..<playersCount {
            name = args[pIndex]
            pIndex += 1
            isMale = args[pIndex] == "+"
            pIndex += 1
            isConnected = args[pIndex] == "+"
            pIndex += 1
            isHuman = args[pIndex] == "+"
            pIndex += 1
            isReady = args[pIndex] == "+"
            pIndex += 1
            
            players.append(PlayerInfo(
                name: name,
                isReady: isReady,
                replic: nil,
                isDeciding: false,
                isHuman: isHuman,
                sum: 0,
                stake: 0,
                state: .none,
                canBeSelected: false
            ))
            
            if isConnected {
                all[name] = Account(name: name, sex: isMale ? .male : .female, isHuman: isHuman, avatar: nil)
            }
        }
        
        for _ in 0..<viewersCount {
            name = args[pIndex]
            pIndex += 1
            isMale = args[pIndex] == "+"
            pIndex += 1
            isConnected = args[pIndex] == "+"
            pIndex += 1
            isHuman = args[pIndex] == "+"
            pIndex += 1
            isReady = args[pIndex] == "+"
            pIndex += 1
            
            all[name] = Account(name: name, sex: isMale ? .male : .female, isHuman: isHuman, avatar: nil)
        }
        
        // TODO: - not yet implemented
        // dispatch(runActionCreators.infoChanged(all, showman, players));
        // dispatch(actionCreators.sendAvatar() as any)
    }
    
    static func onReplic(dispatch: DispatchFunction, state: State, args: [String]) {
        let personCode = args[1]
        var text = ""
        
        for arg in args.dropFirst(2) {
            if !text.isEmpty {
                text += "\n"
            }
            
            text += arg
        }
        
        if personCode == "s" {
            // TODO: - not yet implemented
            // dispatch(runActionCreators.showmanReplicChanged(text));
            return
        }
        
        if personCode.hasPrefix("p"), personCode.count > 1, let index = String(personCode.dropFirst()).toInt() {
            // TODO: - not yet implemented
            // dispatch(runActionCreators.playerReplicChanged(index, text));
            return
        }
        
        if personCode != "l" {
            return
        }
        
        // TODO: - not yet implemented
        // dispatch(runActionCreators.chatMessageAdded({ sender: null, text }));
    }
    
    static func preprocessServerUri(uri: String, dataContext: DataContext) -> String {
        let host: String = !dataContext.contentUris.isEmpty ? dataContext.contentUris[0] : dataContext.serverUri
        
        let result = uri.replacingOccurrences(of: "<SERVERHOST>", with: host)
        
        return result.replacingOccurrences(of: "http:", with: "https:")
    }
    
    static func connected(dispatch: DispatchFunction, state: State, args: [String]) {
        let name = args[3]
        if name == state.user.login {
            return
        }
        
        guard let index = args[2].toInt() else { return }
        let role = args[1]
        let isMale = args[4] == "+"
        
        let account = Account(name: name, sex: isMale ? .male : .female, isHuman: true, avatar: nil)
        
        // TODO: - not yet implemented
        // dispatch(runActionCreators.personAdded(account));
        
        switch role {
        case "showman":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.showmanChanged(name, true, false));
            break
        case "player":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.playerChanged(index, name, true, false));
            break
        default:
            break
        }
    }
    
    static func disconnected(dispatch: DispatchFunction, state: State, args: [String]) {
        let name = args[1]
        
        // TODO: - not yet implemented
        // dispatch(runActionCreators.personRemoved(name));
        
        if state.run.persons.showman.name == name {
            // TODO: - not yet implemented
            // dispatch(runActionCreators.showmanChanged(Constants.ANY_NAME, null, false));
        } else {
            for player in state.run.persons.players where player.name == name {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.playerChanged(i, Constants.ANY_NAME, null, false));
                break
            }
        }
    }
    
    static func config(dispatch: DispatchFunction, state: State, args: [String]) {
        switch args[1] {
        case "ADDTABLE":
            // TODO: - not yet implemented
            // dispatch(runActionCreators.playerAdded());
            break
        case "FREE":
            let personType = args[2]
            guard let index = args[3].toInt() else { break }
            let isPlayer = personType == "player"
            
            if isPlayer {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.playerChanged(index, Constants.ANY_NAME, null, false))
            } else {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.showmanChanged(Constants.ANY_NAME, null, false));)
            }
            
            let account = isPlayer ? state.run.persons.players[index] : state.run.persons.showman
            
            if account.name == state.user.login {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.roleChanged(Role.Viewer));
            }
        case "DELETETABLE":
            guard let index = args[2].toInt() else { return }
            let player = state.run.persons.players[index]
            let person = state.run.persons.all[player.name]
            
            // TODO: - not yet implemented
            // dispatch(runActionCreators.playerDeleted(index));
            
            if let person = person, !person.isHuman {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.personRemoved(person.name));
            } else if player.name == state.user.login {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.roleChanged(Role.Viewer));
            }
        case "SET":
            let personType = args[2]
            guard let index = args[3].toInt() else { return }
            let replacer = args[4]
            let replacerSex = args[5] == "+" ? Sex.male : Sex.female
            
            let isPlayer = personType == "player"
            let account = isPlayer ? state.run.persons.players[index] : state.run.persons.showman
            
            if let person = state.run.persons.all[account.name], !person.isHuman {
                if isPlayer {
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.playerChanged(index, replacer, null, false))
                } else {
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.showmanChanged(replacer, null, false)))
                }
                
                // TODO: - not yet implemented
                // dispatch(runActionCreators.personRemoved(person.name));
                
                let newAccount = Account(name: replacer, sex: replacerSex, isHuman: false, avatar: nil)
                
                // TODO: - not yet implemented
                // dispatch(runActionCreators.personAdded(newAccount));
                break
            }
            
            if state.run.persons.showman.name == replacer { // isPlayer
                // TODO: - not yet implemented
                // dispatch(runActionCreators.showmanChanged(account.name, true, account.isReady));
                // dispatch(runActionCreators.playerChanged(index, replacer, true, state.run.persons.showman.isReady));
                
                if account.name == state.user.login {
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.roleChanged(Role.Showman));
                } else {
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.roleChanged(Role.Player));
                }
                break
            }
            
            for (index, player) in state.run.persons.players.enumerated() where player.name == replacer {
                if isPlayer {
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.playersSwap(index, i));
                } else {
                    let isReady = player.isReady
                    
                    // TODO: - not yet implemented
                    // dispatch(runActionCreators.playerChanged(i, account.name, null, account.isReady));
                    // dispatch(runActionCreators.showmanChanged(replacer, null, isReady));
                    
                    if state.run.persons.showman.name == state.user.login {
                        // TODO: - not yet implemented
                        // dispatch(runActionCreators.roleChanged(Role.Player));
                    } else if replacer == state.user.login {
                        // TODO: - not yet implemented
                        // dispatch(runActionCreators.roleChanged(Role.Showman));
                    }
                }
                return
            }

            if isPlayer {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.playerChanged(index, replacer, null, false))
            } else {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.showmanChanged(replacer, null, false));)
            }
            
            if account.name == state.user.login {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.roleChanged(Role.Viewer));
            } else if replacer == state.user.login {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.roleChanged(isPlayer ? Role.Player : Role.Showman));
            }
        case "CHANGETYPE":
            let personType = args[2]
            guard let index = args[3].toInt() else { break }
            let newType = args[4] == "+"
            let newName = args[5]
            let newSex = args[6] == "+" ? Sex.male : .female
            let isPlayer = personType == "player"
            let account = isPlayer ? state.run.persons.players[index] : state.run.persons.showman
            
            let person = state.run.persons.all[account.name]
            
            if person != nil && person?.isHuman == newType {
                break
            }
            
            if !newType {
                let newAccount = Account(name: newName, sex: newSex, isHuman: false, avatar: nil)
                
                // TODO: - not yet implemented
                // dispatch(runActionCreators.personAdded(newAccount));
            }
            
            if isPlayer {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.playerChanged(index, newName, newType, false))
            } else {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.showmanChanged(newName, newType, false));)
            }

            if newType {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.personRemoved(person.name));
            }
            
            if person?.name == state.user.login {
                // TODO: - not yet implemented
                // dispatch(runActionCreators.roleChanged(Role.Viewer));
            }
        default:
            break
        }
    }
    
    static func getMe(state: State) -> PlayerInfo? {
        let players = state.run.persons.players
        return players.first { $0.name == state.user.login }
    }
}
