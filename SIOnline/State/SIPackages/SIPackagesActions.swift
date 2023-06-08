//
//  SIPackagesActions.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.06.2023.
//

enum SIPackagesActionTypes {
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
