//
//  StringHelpers.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 05.06.2022.
//

extension String {
    func stringFormat(args: [String]) -> String {
        return String(format: self, arguments: args)
    }
}
