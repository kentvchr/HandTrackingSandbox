//
//  ContentView.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 25/02/2024.
//
//  Abstract:
//  A View that contains the Main Window content.
//  If App is in Home phase, display HomeView.
//  If Immersive phase, display Settings.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        switch appState.phase {
        case .home:
            HomeView()
                .onAppear {
                    // Prevent Window resizing
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                        return
                    }
                    windowScene.requestGeometryUpdate(
                        .Vision(
                            resizingRestrictions: UIWindowScene.ResizingRestrictions.none
                        )
                    )
                }
        case .immersion:
            SettingsView()
                .transition(.opacity)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppState())
}
