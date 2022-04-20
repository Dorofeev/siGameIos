//
//  DictionaryExtentsions.swift
//  SIOnline
//
//  Created by u on 16.04.2022.
//

extension Dictionary {
    static func create<T>(collection: [T], selector: (T) -> Int) -> [Int: T] {
        var result = [Int: T]()
        for value in collection {
            result[selector(value)] = value
        }
        return result
    }
    
    mutating func setItem(key: Key, item: Value) {
        self[key] = item
    }
    
    mutating func remove(key: Key) {
        self[key] = nil
    }

    func values() -> [Value] {
        return Array(self.values)
    }
  
    func map(mapper: (Value) -> Value) -> [Key: Value] {
        var temp = self
        for (key, value) in self {
            temp[key] = mapper(value)
        }
        return temp
    }
}
