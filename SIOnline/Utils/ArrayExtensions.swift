//
//  ArrayExtensions.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 16.04.2022.
//
extension Array {
    static func removeFromArray<T: Equatable>(array: [T], item: T) -> [T] {
        return array.filter {
            $0 != item
        }
    }
    
    static func arrayToDictionary<T>(
        array: [T],
        keySelector: (T) -> String
    ) -> [String: T] {
        var temp = [String: T]()
        for value in array {
            temp[keySelector(value)] = value
            
        }
        return temp
    }
    
    static func replace<T>(array: [T], index: Int, item: T) -> [T] {
        let prefix = array.prefix(upTo: index)
        let suffix = array.suffix(from: index + 1)
        return prefix + [item] + suffix
    }
    
}
