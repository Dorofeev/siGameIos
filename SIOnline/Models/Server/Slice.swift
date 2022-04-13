//
//  Slice.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//

class Slice<T> {
    let data: [T]
    let isLastSlice: Bool
    
    init(data: [T], isLastSlice: Bool) {
        self.data = data
        self.isLastSlice = isLastSlice
    }
}
