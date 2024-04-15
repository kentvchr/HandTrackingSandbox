//
//  HandTrackingSandboxApp.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 25/02/2024.
//

import SwiftUI

/// `HandTrackingSandboxApp` is the main entry point of the application.
///
/// Features:
/// - WindowGroup: Main content view container.
/// - ImmersiveSpace: Specialized view for immersive experiences.
/// - Environment Objects: Uses `AppState` to manage and propagate app state across views.
///
/// Behaviors:
/// - Changes in `AppState`'s phase will either open or dismiss an immersive space.
/// - Scene phase changes manage the lifecycle of the immersive space, ensuring it's dismissed when the app is not active.
///

@main
@MainActor
struct HandTrackingSandboxApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup(id: "MenuView") {
            ContentView()
                .environment(appState)
                .onChange(of: appState.phase) { _, newPhase in
                    switch newPhase {
                    case .home:
                        Task {
                            await dismissImmersiveSpace()
                            appState.isImmersiveSpaceShown = false
                        }
                    case .immersion:
                        Task {
                            await openImmersiveSpace(id: "ImmersiveSpace")
                            appState.isImmersiveSpaceShown = true
                        }
                    }
                }
            // If the main window is closed, reset AppState (will dismiss the immersive space).
                .onChange(of: scenePhase) { _, newPhase in
                    Task {
                        if (newPhase == .background || newPhase == .inactive) && appState.isImmersiveSpaceShown {
                            appState = AppState()
                        }
                    }
                }
        }.windowResizability(.contentSize)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(appState)
        }
        .immersionStyle(
            selection: $appState.immersionStyle,
            in: .automatic,
            .mixed,
            .progressive,
            .full
        )
        .upperLimbVisibility(appState.upperLimbVisibility)
    }
}
