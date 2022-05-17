//
//  TimeSettings.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//

private let kTimeForChoosingQuestion = "timeForChoosingQuestion"
private let kTimeForThinkingOnQuestion = "timeForThinkingOnQuestion"
private let kTimeForPrintingAnswer = "timeForPrintingAnswer"
private let kTimeForGivingACat = "timeForGivingACat"
private let kTimeForMakingStake = "timeForMakingStake"
private let kTimeForThinkingOnSpecial = "timeForThinkingOnSpecial"
private let kTimeOfRound = "timeOfRound"
private let kTimeForChoosingFinalTheme = "timeForChoosingFinalTheme"
private let kTimeForFinalThinking = "timeForFinalThinking"
private let kTimeForShowmanDecisions = "timeForShowmanDecisions"
private let kTimeForRightAnswer = "timeForRightAnswer"
private let kTimeForMediaDelay = "timeForMediaDelay"
private let kTimeForBlockingButton = "timeForBlockingButton"

struct TimeSettings: Codable {
    
    var timeForChoosingQuestion: Int
    var timeForThinkingOnQuestion: Int
    var timeForPrintingAnswer: Int
    var timeForGivingACat: Int
    var timeForMakingStake: Int
    var timeForThinkingOnSpecial: Int
    var timeOfRound: Int
    var timeForChoosingFinalTheme: Int
    var timeForFinalThinking: Int
    var timeForShowmanDecisions: Int
    var timeForRightAnswer: Int
    var timeForMediaDelay: Int
    var timeForBlockingButton: Int
    
    subscript(key: String) -> Int {
        get {
            switch key {
            case kTimeForChoosingQuestion:
                return timeForChoosingQuestion
            case kTimeForThinkingOnQuestion:
                return timeForThinkingOnQuestion
            case kTimeForPrintingAnswer:
                return timeForPrintingAnswer
            case kTimeForGivingACat:
                return timeForGivingACat
            case kTimeForMakingStake:
                return timeForMakingStake
            case kTimeForThinkingOnSpecial:
                return timeForThinkingOnSpecial
            case kTimeOfRound:
                return timeOfRound
            case kTimeForChoosingFinalTheme:
                return timeForChoosingFinalTheme
            case kTimeForFinalThinking:
                return timeForFinalThinking
            case kTimeForShowmanDecisions:
                return timeForShowmanDecisions
            case kTimeForRightAnswer:
                return timeForRightAnswer
            case kTimeForMediaDelay:
                return timeForMediaDelay
            case kTimeForBlockingButton:
                return timeForBlockingButton
            default:
                fatalError("no such time settings \(key)")
            }
        }
        set(newValue) {
            switch key {
            case kTimeForChoosingQuestion:
                timeForChoosingQuestion = newValue
            case kTimeForThinkingOnQuestion:
                timeForThinkingOnQuestion = newValue
            case kTimeForPrintingAnswer:
                timeForPrintingAnswer = newValue
            case kTimeForGivingACat:
                timeForGivingACat = newValue
            case kTimeForMakingStake:
                timeForMakingStake = newValue
            case kTimeForThinkingOnSpecial:
                timeForThinkingOnSpecial = newValue
            case kTimeOfRound:
                timeOfRound = newValue
            case kTimeForChoosingFinalTheme:
                timeForChoosingFinalTheme = newValue
            case kTimeForFinalThinking:
                timeForFinalThinking = newValue
            case kTimeForShowmanDecisions:
                timeForShowmanDecisions = newValue
            case kTimeForRightAnswer:
                timeForRightAnswer = newValue
            case kTimeForMediaDelay:
                timeForMediaDelay = newValue
            case kTimeForBlockingButton:
                timeForBlockingButton = newValue
            default:
                fatalError("no such time settings \(key)")
            }
        }
    }
}
