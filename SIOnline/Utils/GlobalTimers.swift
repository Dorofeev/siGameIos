//
//  GlobalTimers.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 04.06.2022.
//
import Foundation

class GlobalTimers {
    static var timers: [Int: Timer] = [:]
    
    static func clearTimeout(id: Int) {
        guard let timer = timers[id] else {
            return
        }
        timer.invalidate()
        timers[id] = nil
    }
    static func setTimeout(delay: TimeInterval, block: @escaping () -> Void) {
        let timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            block()
        }
        timers[timers.count] = timer
    }
}
