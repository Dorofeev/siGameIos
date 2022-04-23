//
//  TableReducer.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 23.04.2022.
//

import ReSwift

var tableReducer: Reducer<TableState> = { action, state in
    guard var state = state else { return TableState.initialState() }
    guard let action = action as? KnownTableAction else { return state }
    switch action {
    case .showLogo:
        state.mode = TableMode.logo
    case .showGameThemes(let gameThemes):
        state.mode = TableMode.gameThemes
        state.gameThemes = gameThemes
    case .showRoundThemes(let roundThemes, let isFinal, let display):
        if display {
            state.mode = isFinal ? TableMode.final : TableMode.roundThemes
        }
        state.roundInfo = roundThemes
    case .showText(let text, let animateReading):
        state.mode = TableMode.text
        state.text = text
        state.animateReading = animateReading
    case .showAnswer(let text):
        state.mode = TableMode.answer
        state.text = text
    case .showRoundTable:
        state.mode = TableMode.roundTable
        state.activeThemeIndex = -1
        state.actionQuestionIndex = -1
    case .blinkQuestion(let themeIndex, let questionIndex):
        state.activeThemeIndex = themeIndex
        state.actionQuestionIndex = questionIndex
    case .blinkTheme(let themeIndex):
        state.activeThemeIndex = themeIndex
    case .removeQuestion(let themeIndex, let questionIndex):
        var questions = state.roundInfo[themeIndex].questions
        questions.replace(index: questionIndex, item: -1)
        state.roundInfo.replace(
            index: themeIndex,
            item: ThemeInfo(
                name: state.roundInfo[themeIndex].name,
                questions: questions
            )
        )
    case .removeTheme(let themeIndex):
        state.activeThemeIndex = -1
        state.roundInfo.replace(
            index: themeIndex,
            item: ThemeInfo(
                name: "",
                questions: state.roundInfo[themeIndex].questions
            )
        )
    case .showPartialText(let textShape):
        state.mode = TableMode.partialText
        state.text = ""
        state.tail = textShape
    default: break
    }
return state
}
