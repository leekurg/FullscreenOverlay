//
//  OverlayModifier.swift
//
//
//  Created by Илья Аникин on 01.08.2024.
//

import SwiftUI

public extension View {
    func fullscreenOverlay<Content: View>(
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) -> some View {
        modifier(OverlayModifier(isPresented: isPresented, overlay: content))
    }
}

struct OverlayModifier<Overlay: View>: ViewModifier {
    @Environment(FullscreenOverlayPresenter.self) private var presenter
    @Environment(\.overlayTransitionAnimation) private var transitionAnimation
    
    @Binding var isPresented: Bool
    let overlay: () -> Overlay
    
    @State private var overlayId = UUID()
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) {
                if isPresented {
                    dprint(presenter.isVerbose, "overlay [\(overlayId)]: present me 🤲")
                    var presentedId: UUID?
                    withAnimation(transitionAnimation.insertion) {
                        presentedId = presenter.present(id: overlayId, content: overlay)
                    }
                    if presentedId == nil { isPresented = false }
                } else {
                    if presenter.isStacked(overlayId) {
                        dprint(presenter.isVerbose, "overlay[\(overlayId)]: dismiss me 🫠")
                        withAnimation(transitionAnimation.removal) {
                            presenter.dismiss(overlayId)
                        }
                    }
                }
            }
            .onChange(of: presenter.stack) {
                if presenter.stack.find(overlayId) == nil { isPresented = false }
            }
    }
}
