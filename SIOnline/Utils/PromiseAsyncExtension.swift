//
//  PromiseAsyncExtension.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 24.07.2022.
//

import PromiseKit

extension Promise {
    func async() async throws -> T {
        return try await withCheckedThrowingContinuation({ continuation in
            self.done { value in
                continuation.resume(returning: value)
            }.catch { error in
                continuation.resume(throwing: error)
            }
        })
    }
}
