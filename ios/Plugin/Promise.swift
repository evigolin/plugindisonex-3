//
//  Promise.swift
//  Scan-Ocr
//
//  Created by Virtual-Tec on 30/09/21.
//

import Foundation

class Promise<Value> {

    enum State<T> {
        case pending
        case resolved(T)
    }

    private var state: State<Value> = .pending
    // We now store an array instead of a single function
    private var callbacks: [(Value) -> Void] = []

    init(executor: (_ resolve: @escaping (Value) -> Void) -> Void) {
        executor(resolve)
    }

    func then(onResolved: @escaping (Value) -> Void) {
        callbacks.append(onResolved)
        triggerCallbacksIfResolved()
    }

    private func resolve(_ value: Value) -> Void {
        updateState(to: .resolved(value))
    }

    private func updateState(to newState: State<Value>) {
        guard case .pending = state else { return }
        state = newState
        triggerCallbacksIfResolved()
    }

    private func triggerCallbacksIfResolved() {
        guard case let .resolved(value) = state else { return }
        // We trigger all the callbacks
        callbacks.forEach { callback in callback(value) }
        callbacks.removeAll()
    }
}
