//
//  PlayerInfo.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 12.04.2022.
//

class PlayerInfo: PersonInfo {
    var sum: Int
    var stake: Int
    var state: PlayerStates
    var canBeSelected: Bool
    
    init(
        name: String,
        isReady: Bool,
        replic: String?,
        isDeciding: Bool,
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
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
