import ComposableArchitecture
import SwiftUI

struct SheetStoreView<State, Action, PresentedContent>: View where PresentedContent: View {

    let store: Store<State?, Action>
    let presentation: (_ presentationStore: Store<State, Action>) -> PresentedContent
    let action: (_ isActive: Bool) -> Void

    var body: some View {
        WithViewStore(store.scope(state: { $0 != nil })) { viewStore in
            EmptyView()
                .sheet(
                    isPresented: Binding(
                        get: { viewStore.state },
                        set: action
                    ),
                    content: {
                        IfLetStore(
                            store.scope(state: replayNonNil()),
                            then: presentation
                        )
                    }
                )
        }
    }
}

public extension View {
    /// Adds `sheet`, using `Store` with an optional `State`.
    ///
    /// - Sheet is active if `State` is non-`nil` and inactive when it's `nil`.
    /// - Sheet's presentation is generated using last non-`nil` state value.
    ///
    /// - Parameters:
    ///   - store: store with optional state
    ///   - presentation: closure that creates sheet's presented view
    ///   - onDismiss: closure invoked when sheet is dismissed
    /// - Returns: view with with a sheet added.
    func sheet<State, Action, PresentedContent>(
        _ store: Store<State?, Action>,
        presentation: @escaping (_ presentationStore: Store<State, Action>) -> PresentedContent,
        onDismiss: @escaping () -> Void
    ) -> some View
    where PresentedContent: View
    {
        background(
            SheetStoreView(
                store: store,
                presentation: presentation,
                action: { isActive in
                    if isActive == false {
                        onDismiss()
                    }
                }
            )
        )
    }
}
