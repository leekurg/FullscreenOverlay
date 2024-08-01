//
//  RootContainerModifier.swift
//  
//
//  Created by Илья Аникин on 01.08.2024.
//

import SwiftUI

public extension View {
    func fullscreenOverlayRoot(_ transition: AnyTransition = .fullscreenOverlay) -> some View {
        modifier(RootContainerModifier(transition: transition))
    }
}

public extension AnyTransition {
    static let fullscreenOverlay: AnyTransition = .scale(scale: 1.5).combined(with: .opacity)
}

struct RootContainerModifier: ViewModifier {
    @Environment(FullscreenOverlayPresenter.self) private var presenter
    @Environment(\.overlayTransitionAnimation) var transitionAnimation
    
    let transition: AnyTransition

    private let closeButtonSize = 20.0
    private let closeButtonPadding = 15.0

    func body(content: Content) -> some View {
        content
            .overlay {
                if !presenter.stack.isEmpty {
                    ZStack {
                        ForEach(presenter.stack) { entry in
                            entry.view
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .overlay(alignment: .topTrailing) {
                                    XMarkButton(size: closeButtonSize) {
                                        withAnimation(transitionAnimation.removal) {
                                            presenter.dismiss(entry.id)
                                        }
                                    }
                                    .padding(closeButtonPadding)
                                    //TODO: support orientation change
//                                    .padding(.top, -(closeButtonSize + 2 * closeButtonPadding))
                                }
                                .zIndex(Double(entry.deep))
                                .background(.ultraThinMaterial, ignoresSafeAreaEdges: .all)
                                .transition(transition)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(transition)
                }
            }
    }
}
