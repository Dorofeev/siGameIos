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
    
    static func setItem<K: Hashable, T>(record: [K: T], key: K, item: T) -> [K: T] {
        var temp = record
        temp[key] = item
        return temp
    }
    
    static func remove<T>(record: [Int: T], key: Int) -> [Int: T] {
        var temp = record
        temp[key] = nil
        return temp
    }
    
    static func removeS<T>(record: [String: T], key: String) -> [String: T] {
        var temp = record
        temp[key] = nil
        return temp
    }

    static func values<T>(record: [Int: T]) -> [T] {
        record.keys.map { key in
            record[key]!
        }
    }
  
    static func map<T>(record: [String: T], mapper: (T) -> T) -> [String: T] {
        var temp = record
        for (key, value) in record {
            temp[key] = mapper(value)
        }
        return temp
    }
}
