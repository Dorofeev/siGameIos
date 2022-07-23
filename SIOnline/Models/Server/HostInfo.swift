//
//  HostInfo.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 13.04.2022.
//

struct HostInfo: Decodable {
    let name: String
    let host: String
    let port: String
    let packagesPublicBaseUrl: String?
    let contentPublicBaseUrls: [String]?
    let license: String
}
