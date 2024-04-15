//
//  SettingsView.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 25/02/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(AppState.self) private var appState
    
    var body: some View {
        @Bindable var appState = appState
        VStack {
            Text("Settings")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
            Toggle(" Immersive", systemImage: "sparkles", isOn: $appState.showImmersive)
                .tint(.blue)
                .onChange(of: appState.showImmersive) { _, showImmersive in
                    if showImmersive && appState.virtualWorldModel.isLoaded {
                        appState.addEntityToScene(appState.virtualWorldModel.contentEntity)
                        appState.addEntityToScene(appState.virtualWorldModel.contentEntity)
                        appState.sceneReconstructionModel.contentEntity.removeFromParent()
                    } else {
                        appState.virtualWorldModel.contentEntity.removeFromParent()
                        appState.virtualWorldModel.contentEntity.removeFromParent()
                        appState.addEntityToScene(appState.sceneReconstructionModel.contentEntity)
                    }
                }
                .onAppear() {
                    appState.addEntityToScene(appState.sceneReconstructionModel.contentEntity)
                }
            Divider()
            Toggle("Hand Occlusion", systemImage: "eye.fill", isOn: $appState.showUpperLimb)
                .tint(.blue)
                .onChange(of: appState.showUpperLimb) { _, showUpperLimb in
                    appState.upperLimbVisibility = showUpperLimb ? .visible : .hidden
                }
            Divider()
            Text("\(Image(systemName: "cube.transparent.fill"))  Skeleton")
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Toggle("Left Hand Toggle", isOn: $appState.showLeftSkeleton)
                    .toggleStyle(HandToggleStyle(chirality: .left))
                    .onChange(of: appState.showLeftSkeleton) { _, showLeftSkeleton in
                        if showLeftSkeleton {
                            appState.addEntityToScene(appState.handTrackingModel.leftHand?.entity)
                        } else {
                            appState.removeEntityFromScene(appState.handTrackingModel.leftHand?.entity)
                        }
                    }
                    .disabled(appState.handTrackingModel.leftHand == nil)
                Toggle("Right Hand Toggle", isOn: $appState.showRightSkeleton)
                    .toggleStyle(HandToggleStyle(chirality: .right))
                    .onChange(of: appState.showRightSkeleton) { _, showRightSkeleton in
                        if showRightSkeleton {
                            appState.addEntityToScene(appState.handTrackingModel.rightHand?.entity)
                        } else {
                            appState.removeEntityFromScene(appState.handTrackingModel.rightHand?.entity)
                        }
                    }
                    .disabled(appState.handTrackingModel.rightHand == nil)
            }
            Divider()
            Button("Exit Hand Tracking") {
                appState.phase = .home
            }
            .padding(.top, 64)
        }
        .frame(width: 400)
        .padding()
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
        .glassBackgroundEffect()
}
