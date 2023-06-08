//
//  SIPackagesActionCreators.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 08.06.2023.
//

import ReSwift
import ReSwiftThunk

class SIPackagesActionCreators {
    
    static func searchPackages() -> KnownSIPackagesAction {
        return .searchPackages
    }
    
    static func searchPackagesFinished(packages: [SIPackageInfo]) -> KnownSIPackagesAction {
        return .searchPackagesFinished(packages: packages)
    }
    
    static func searchPackagesError(error: String?) -> KnownSIPackagesAction {
        return .searchPackagesError(error: error)
    }
    
    static func receiveAuthors() -> KnownSIPackagesAction {
        return .receiveAuthors
    }
    
    static func receiveAuthorsFinished(authors: [SearchEntity]) -> KnownSIPackagesAction {
        return .receiveAuthorsFinished(authors: authors)
    }
    
    static func receiveTags() -> KnownSIPackagesAction {
        return .receiveTags
    }
    
    static func receiveTagsFinished(tags: [SearchEntity]) -> KnownSIPackagesAction {
        return .receiveTagsFinished(tags: tags)
    }
    
    static func receivePublishers() -> KnownSIPackagesAction {
        return .receivePublishers
    }
    
    static func receivePublishersFinished(publishers: [SearchEntity]) -> KnownSIPackagesAction {
        return .receivePublishersFinished(publishers: publishers)
    }
    
    static func receiveAuthorsThunk() -> Thunk<KnownSIPackagesAction> {
        return Thunk { dispatch, getState in
            dispatch(receiveAuthors())
            let apiUri = Index.dataContext.config.apiUri
            let url = URL(string: "\(apiUri)/Authors")!
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    if let error = error {
                        dispatch(searchPackagesError(error: getErrorMessage(e: error)))
                    }
                    return
                }
                
                do {
                    let authors = try JSONDecoder().decode([SearchEntity].self, from: data)
                    dispatch(receiveAuthorsFinished(authors: authors))
                } catch {
                    dispatch(searchPackagesError(error: getErrorMessage(e: error)))
                }
            }
            
            task.resume()
        }
    }
    
    static func receiveTagsThunk() -> Thunk<KnownSIPackagesAction> {
        return Thunk { dispatch, getState in
            dispatch(receiveTags())
            let apiUri = Index.dataContext.config.apiUri
            let url = URL(string: "\(apiUri)/Tags")!
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    if let error = error {
                        dispatch(searchPackagesError(error: getErrorMessage(e: error)))
                    }
                    return
                }
                
                do {
                    let tags = try JSONDecoder().decode([SearchEntity].self, from: data)
                    dispatch(receiveTagsFinished(tags: tags))
                } catch {
                    dispatch(searchPackagesError(error: getErrorMessage(e: error)))
                }
            }
            
            task.resume()
        }
    }

    static func receivePublishersThunk() -> Thunk<KnownSIPackagesAction> {
        return Thunk { dispatch, getState in
            dispatch(receivePublishers())
            let apiUri = Index.dataContext.config.apiUri
            let url = URL(string: "\(apiUri)/Publishers")!
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    if let error = error {
                        dispatch(searchPackagesError(error: getErrorMessage(e: error)))
                    }
                    return
                }
                
                do {
                    let publishers = try JSONDecoder().decode([SearchEntity].self, from: data)
                    dispatch(receivePublishersFinished(publishers: publishers))
                } catch {
                    dispatch(searchPackagesError(error: getErrorMessage(e: error)))
                }
            }
            
            task.resume()
        }
    }

    static func searchPackagesThunk(filters: PackageFilters = .initial()) -> Thunk<KnownSIPackagesAction> {
        return Thunk { dispatch, _ in
            dispatch(searchPackages())
            let apiUri = Index.dataContext.config.apiUri
            
            var urlComponents = URLComponents(string: "\(apiUri)/FilteredPackages")!
            urlComponents.queryItems = filters.dictionaryValue.compactMap { key, value in
                URLQueryItem(name: key, value: value)
            }
            
            guard let url = urlComponents.url else {
                dispatch(searchPackagesError(error: "Invalid URL"))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    if let error = error {
                        dispatch(searchPackagesError(error: getErrorMessage(e: error)))
                    }
                    return
                }
                
                do {
                    let packages = try JSONDecoder().decode([SIPackageInfo].self, from: data)
                    dispatch(searchPackagesFinished(packages: packages))
                } catch {
                    dispatch(searchPackagesError(error: getErrorMessage(e: error)))
                }
            }
            
            task.resume()
        }
    }
}
