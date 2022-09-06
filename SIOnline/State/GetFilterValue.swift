//
//  GetFilterValue.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 06.09.2022.
//

extension GamesFilter {
    static func getFilterValue(gameFilter: Int) -> String {
        let onlyNew = gameFilter & GamesFilter.new.rawValue > 0
        let sport = gameFilter & GamesFilter.sport.rawValue > 0
        let tv = gameFilter & GamesFilter.tv.rawValue > 0
        let noPassword = gameFilter & GamesFilter.noPassword.rawValue > 0
        
        if (((sport && tv) || (!sport && !tv)) && !onlyNew && !noPassword) {
            return R.string.localizable.all()
        }
        
        var value: String = ""
        
        if onlyNew {
            value += R.string.localizable.new()
        }
        
        if sport && !tv {
            if !value.isEmpty {
                value += ", "
            }
            value += R.string.localizable.sportPlural()
        }
        
        if tv && !sport {
            if !value.isEmpty {
                value += ", "
            }
            value += R.string.localizable.tv()
        }
        
        if noPassword {
            if !value.isEmpty {
                value += ", "
            }
            value += R.string.localizable.withoutPassword()
        }
        
        return value
    }
}
