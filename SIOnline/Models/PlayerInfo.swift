//
//  PlayerInfo.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

class PlayerInfo: PersonInfo {
    let sum: Int
    let stake: Int
    let state: PlayerStates
    let canBeSelected: Bool
    
    init(
        name: String,
        isReady: Bool,
        replic: String?
        , isDeciding: Bool,
        isHuman: Bool,
        sum: Int,
        stake: Int,
        state: PlayerStates,
        canBeSelected: Bool
    ) {
        self.sum = sum
        self.stake = stake
        self.state = state
        self.canBeSelected = canBeSelected
        super.init(name: name, isReady: isReady, replic: replic, isDeciding: isDeciding, isHuman: isHuman)
    }
}
