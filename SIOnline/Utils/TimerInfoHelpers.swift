//
//  TimerInfoHelpers.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 24.04.2022.
//

extension Timers {
    mutating func updateTimers(timerIndex: Int, updater: (inout TimerInfo) -> Void) {
        switch timerIndex {
        case 0:
            updater(&round)
        case 1:
            updater(&press)
        case 2:
            updater(&decision)
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
