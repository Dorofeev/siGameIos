//
//  Message.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 16.07.2022.
//
struct Message: Decodable {
    var isSystem: Bool
    var sender: String
    var text: String
}

