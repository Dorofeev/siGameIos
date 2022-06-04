//
//  tableActionCreators.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 29.05.2022.
//

class TableActionCreators {
    static let showLogo: () -> TableActionTypes = {
        TableActionTypes.showLogo
    }
    
    static let showGameThemes: ([String]) -> TableActionTypes = { gameThemes in
        TableActionTypes.showGameThemes(gameThemes: gameThemes)
    }
    
    static let showRoundThemes: ([ThemeInfo], Bool, Bool) -> TableActionTypes
    = { roundThemes, isFinal, display in
        TableActionTypes.showRoundThemes(
            roundThemes: roundThemes,
            isFinal: isFinal,
            display: display
        )
    }
    
    static let showText: (String, Bool) -> TableActionTypes = { text, animateReading in
        TableActionTypes.showText(text: text, animateReading: animateReading)
    }
    
    static let showAnswer: (String) -> TableActionTypes = { text in
        TableActionTypes.showAnswer(text: text)
    }
    
    static let showRoundTable: () -> TableActionTypes = {
        TableActionTypes.showRoundTable
    }
    
    static let blinkQuestion: (Int, Int) -> TableActionTypes = { themeIndex, questionIndex in
        TableActionTypes.blinkQuestion(
            themeIndex: themeIndex,
            questionIndex: questionIndex
        )
    }
    
    static let blinkTheme: (Int) -> TableActionTypes = { themeIndex in
       
        TableActionTypes.blinkTheme(themeIndex: themeIndex)
    }
    
    static let removeQuestion: (Int, Int) -> TableActionTypes = { themeIndex, questionIndex in
        TableActionTypes.removeQuestion(themeIndex: themeIndex, questionIndex: questionIndex)
    }
    
    static let removeTheme: (Int) -> TableActionTypes = { themeIndex in
        TableActionTypes.removeTheme(themeIndex: themeIndex)
    }
    
    static let showPartialText: (String) -> TableActionTypes = { textShape in
        TableActionTypes.showPartialText(textShape: textShape)
    }
    
    static let appendPartialText: (String) -> TableActionTypes = { text in
        TableActionTypes.appendPatrialText(text: text)
    }
    
    static let showImage: (String) -> TableActionTypes = { uri in
        TableActionTypes.showImage(uri: uri)
    }
    
    static let showAudio: (String) -> TableActionTypes = { uri in
        TableActionTypes.showAudio(uri: uri)
    }
    
    static let showVideo: (String) -> TableActionTypes = { uri in
        TableActionTypes.showVideo(uri: uri)
    }
    
    static func showSpecial(text: String, activeThemeIndex: Int = -1) -> TableActionTypes {
        TableActionTypes.showSpecial(text: text, activeThemeIndex: activeThemeIndex)
    }
    
    static let canPressChanged: (Bool) -> TableActionTypes = { canPress in
        TableActionTypes.canPressChanged(canPress: canPress)
    }
    
    static let isSelectableChanged: (Bool) -> TableActionTypes = {isSelectable in
        TableActionTypes.isSelectableChanged(isSelectable: isSelectable)
    }
    
    static let resumeMedia: () -> TableActionTypes = {
        TableActionTypes.resumeMedia
    }
    
    static let captionChanged: (String) -> TableActionTypes = {caption in
        TableActionTypes.captionChanged(caption: caption)
    }
}
