//
//  ErrorHelpers.swift
//  SIOnline
//
//  Created by Anna Kuptsova on 29.05.2022.
//

func getErrorMessage(e: Any) -> String {
    if let e = e as? Error {
        return e.localizedDescription
    } else if let e = e as? [String: Any] {
        return e.description
    } else {
        return R.string.localizable.unknownError()
    }
}
