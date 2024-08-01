//
//  FullscreenOverlayPresenter.swift
//
//
//  Created by Илья Аникин on 01.08.2024.
//

import SwiftUI

@Observable public class FullscreenOverlayPresenter {
    public private(set) var stack: [StackEntry] = []
    let isVerbose: Bool
    
    public init(verbose: Bool = false) {
        self.isVerbose = verbose
    }
    
    /// Present a *content* with given **id**.
    ///
    /// - Returns: Returns presenting 'Destination' or **nil** when **id** is in stack already.
    ///
    public func present<Content: View>(id: UUID, content: @escaping () -> Content) -> UUID? {
        if let _ = stack.find(id) {
            dprint(isVerbose, "⚠️ id \(id) is already in stack - skip")
            return nil
        }
        
        stack.append(StackEntry(id: id, deep: (stack.last?.deep ?? 0) + 1, view: AnyView(content())))
        dprint(isVerbose, "✅ presenting \(id)")
        return id
    }
    
    public func dismiss(_ id: UUID) {
        let presentedIndex = stack.firstIndex { $0.id == id }
        
        if let presentedIndex {
            stack.remove(at: presentedIndex)
            dprint(isVerbose, "🙈 dismiss \(id)")
        } else {
            dprint(isVerbose, "⚠️ id \(id) is not found in hierarchy - skip")
        }
    }
    
    public func isStacked(_ id: UUID) -> Bool {
        stack.find(id) != nil
    }
    
    public func popToRoot() {
        stack.removeAll()
    }
    
    public func popFirst() {
        stack.removeFirst()
    }
    
    public func popLast() {
        stack.removeLast()
    }
}

public extension FullscreenOverlayPresenter {
    struct StackEntry: Identifiable, Equatable {
        public let id: UUID
        public let deep: Int
        public let view: AnyView
        
        public static func == (lhs: StackEntry, rhs: StackEntry) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension Array where Element == FullscreenOverlayPresenter.StackEntry {
    func find(_ entryId: UUID) -> FullscreenOverlayPresenter.StackEntry? {
        first { $0.id == entryId }
    }
}
