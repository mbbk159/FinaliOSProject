//
//  Injected.swift
//  discoverMendelu
//
//  Created by Macek<3 on 29.05.2025.
//

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
