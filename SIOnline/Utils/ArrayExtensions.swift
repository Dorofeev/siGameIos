//
//  ArrayExtensions.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 16.04.2022.
//
extension Array where Element: Equatable {
    mutating func removeFromArray(item: Element) {
        self.removeAll { item == $0 }
    }
    
    func arrayToDictionary(
        keySelector: (Element) -> String
    ) -> [String: Element] {
        var temp = [String: Element]()
        for value in self {
            temp[keySelector(value)] = value
        }
        return temp
    }
    
    mutating func replace(index: Int, item: Element) {
        self[index] = item
    }
    
    static func swap<T>(array: [T], index1: Int, index2: Int) -> [T] {
        var temp = array
        (temp[index1], temp[index2]) = (temp[index2], temp[index1])
        return temp
    }
}
