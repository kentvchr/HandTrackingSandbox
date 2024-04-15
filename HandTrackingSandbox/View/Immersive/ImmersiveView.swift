//
//  ImmersiveView.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 25/02/2024.
//

import SwiftUI
import RealityKit
import RealityKitContent

/// `ImmersiveView` is a SwiftUI View that integrates AR functionalities using ARKit and RealityKit for immersive experiences.
///
/// The view utilizes the `AppState` to access and manage AR sessions and models including hand tracking and scene reconstruction.
/// - Properties:
///   - appState: Accesses the global state of the application for AR configurations and updates.
///   - handTrackingModel: Manages the hand tracking features.
///   - sceneReconstructionModel: Handles the updates for scene reconstruction.
///
/// The view is designed to dynamically update based on changes in the AR environment, processing hand updates, and scene changes, while also responding to user gestures to interact with the AR scene.
///
/// It includes:
/// - A `RealityView` to display and interact with the AR content.
/// - Asynchronous tasks to run AR session and process updates for hand tracking and scene reconstruction.
/// - A gesture handler for spatial interactions, enabling actions like spawning objects at tapped locations in the AR space.
struct ImmersiveView: View {
    
    @Environment(AppState.self) private var appState
    
    @MainActor
    var handTrackingModel: HandTrackingModel {
        appState.handTrackingModel
    }
    
    @MainActor
    var sceneReconstructionModel: SceneReconstructionModel {
        appState.sceneReconstructionModel
    }
    
    var body: some View {
        @Bindable var appState = appState
        RealityView { content in
            content.add(appState.rootEntity)
        } update: { updateContent in
            // Triggered when View State is updated.
        }
        .task {
            await appState.runSession()
        }
        .task {
            await handTrackingModel.processHandUpdates()
        }
        .task {
            await sceneReconstructionModel.processSceneReconstructionUpdates()
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({ value in
            let location3D = value.convert(value.location3D, from: .global, to: .scene)
            appState.spawnCube(tapLocation: location3D)
        }))
    }
}
