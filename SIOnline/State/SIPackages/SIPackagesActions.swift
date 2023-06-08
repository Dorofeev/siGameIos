//
//  SIPackagesActions.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.06.2023.
//

import ReSwift

typealias KnownSIPackagesAction = SIPackagesActionTypes
enum SIPackagesActionTypes: Action {
    case searchPackages
    case searchPackagesFinished(packages: [SIPackageInfo])
    case searchPackagesError(error: String?)
    case receiveAuthors
    case receiveAuthorsFinished(authors: [SearchEntity])
    case receiveTags
    case receiveTagsFinished(tags: [SearchEntity])
    case receivePublishers
    case receivePublishersFinished(publishers: [SearchEntity])
}
