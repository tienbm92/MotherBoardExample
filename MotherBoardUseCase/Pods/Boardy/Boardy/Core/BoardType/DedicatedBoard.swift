//
//  DedicatedBoard.swift
//  Boardy
//
//  Created by NGUYEN CHI CONG on 3/18/20.
//

import Foundation

// MARK: - AdaptableBoard

public protocol AdaptableBoard {
    associatedtype InputType

    var inputAdapters: [(Any?) -> InputType?] { get }
}

extension AdaptableBoard {
    public func convertOptionToInput(_ option: Any?) -> InputType? {
        var input: InputType?
        for adapter in validAdapters {
            input = adapter(option)
            if input != nil { break }
        }
        return input
    }

    public var inputAdapters: [(Any?) -> InputType?] { [] }

    var validAdapters: [(Any?) -> InputType?] {
        let defaultAdapter: (Any?) -> InputType? = { $0 as? InputType }
        return inputAdapters + [defaultAdapter]
    }
}

// MARK: - DedicatedBoard

public protocol DedicatedBoard: AdaptableBoard, ActivatableBoard {
    func activate(withInput input: InputType?)
}

extension DedicatedBoard {
    public func activate(withOption option: Any?) {
        activate(withInput: convertOptionToInput(option))
    }
}

// MARK: - GuaranteedBoard

public protocol GuaranteedBoard: AdaptableBoard, ActivatableBoard {
    func activate(withGuaranteedInput input: InputType)
}

extension GuaranteedBoard {
    public func activate(withOption option: Any?) {
        guard let input = convertOptionToInput(option) else {
            assertionFailure("Cannot convert input from \(String(describing: option)) to type \(InputType.self)")
            return
        }
        activate(withGuaranteedInput: input)
    }
}
