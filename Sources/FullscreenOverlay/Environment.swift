//
//  Environment.swift
//
//
//  Created by Илья Аникин on 01.08.2024.
//

import SwiftUI

public struct OverlayTransitionAnimation {
    public let insertion: Animation
    public let removal: Animation
}

public extension EnvironmentValues {
    var overlayTransitionAnimation: OverlayTransitionAnimation {
        get { self[OverlayTransitionAnimationKey.self] }
        set { self[OverlayTransitionAnimationKey.self] = newValue }
    }
}

struct OverlayTransitionAnimationKey: EnvironmentKey {
    static let defaultValue: OverlayTransitionAnimation = .init(
        insertion: .spring(duration: 0.5),
        removal: .linear(duration: 0.3)
     )
}
