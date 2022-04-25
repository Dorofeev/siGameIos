//
//  TimerInfoHelpers.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 24.04.2022.
//

extension Timers {
    mutating func updateTimers(timerIndex: Int, updater: (TimerInfo) -> TimerInfo) {
        switch timerIndex {
        case 0:
            round = updater(round)
        case 1:
            press = updater(press)
        case 2:
            decision = updater(decision)
        default:
            break
        }
    }
}

extension TimerInfo {
    func isRunning() -> Bool {
        return !isPausedBySystem && !isPausedByUser
    }
}
