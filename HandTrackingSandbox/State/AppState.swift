//
//  AppState.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 25/02/2024.
//

/// Manages the global state of the application.
///
/// AppState initializes and manages ARKit session, scene reconstruction, and hand tracking providers.
/// It also manages the several models such as hand tracking and scene reconstruction models, and settings related to the user's immersive experience preferences.
///
/// - Properties:
///   - phase: Current phase of the app (e.g., home, immersion).
///   - session: Manages AR features and tracking.
///   - sceneReconstructionProvider: Provides scene reconstruction data.
///   - handTrackingProvider: Provides hand tracking data.
///   - isImmersiveSpaceShown: Indicates if the immersive view is loaded and displayed.
///   - rootEntity: The root entity for the `RealityView` scene.
///   - handTrackingModel: Model for hand tracking within the app.
///   - sceneReconstructionModel: Model for scene reconstruction.
///   - virtualWorldModel: Model representing the virtual world.
///   - immersionStyle: Style of immersion for the user.
///   - upperLimbVisibility: Visibility setting for hand occlusion..
///
/// - Methods:
///   - init(): Initializes the AR session and providers.
///   - requestAuthorization(): Requests necessary permissions for AR features.
///   - runSession(): Starts the AR session with configured features.

import Foundation
import SwiftUI
import ARKit
import RealityKit
import RealityKitContent

@Observable
@MainActor
class AppState {
    public var phase: AppPhase = .home
    
    /// The app's AR session.
    private var session: ARKitSession
    private var sceneReconstructionProvider: SceneReconstructionProvider
    private var handTrackingProvider: HandTrackingProvider
    
    /// Confirm is Immersive View is loaded
    public var isImmersiveSpaceShown = false
    
    /// The root entity for the `RealityView` scene. Storing this in application
    /// state means any code in the app can get access to it.
    public var rootEntity = Entity()
    
    /// Models
    public var handTrackingModel: HandTrackingModel
    public var sceneReconstructionModel: SceneReconstructionModel
    public var virtualWorldModel: VirtualWorldModel

    /// User settings
    public var immersionStyle: ImmersionStyle = .mixed
    public var upperLimbVisibility: Visibility = .automatic
    public var showImmersive: Bool = false
    public var showUpperLimb: Bool = false
    public var showLeftSkeleton: Bool = false
    public var showRightSkeleton: Bool = false
    
    /// Initializes the AppState.
    /// This initializer sets up the ARKit session and configures providers for hand tracking and scene reconstruction.
    /// It also initializes models associated with these functionalities and starts necessary asynchronous tasks:
    /// - Requests the necessary authorizations for AR features.
    /// - Begins loading virtual world data.
    ///
    /// Components:
    /// - `session`: ARKitSession, manages AR session operations.
    /// - `handTrackingProvider`: Tracks hand movements.
    /// - `sceneReconstructionProvider`: Manages 3D scene data capturing.
    /// - `handTrackingModel`: Manages updates and states of hand tracking.
    /// - `sceneReconstructionModel`: Manages 3D scene updates.
    /// - `virtualWorldModel`: Handles virtual world interactions and data.
    ///
    /// Two asynchronous tasks are started to handle permissions and to load virtual world components, preparing the application for AR interactions.
    init() {
        let session = ARKitSession()
        let handTrackingProvider = HandTrackingProvider()
        let sceneReconstructionProvider = SceneReconstructionProvider()
        self.session = session
        self.handTrackingProvider = handTrackingProvider
        self.sceneReconstructionProvider = sceneReconstructionProvider
        self.handTrackingModel = HandTrackingModel(session: session, handTracking: handTrackingProvider)
        self.sceneReconstructionModel = SceneReconstructionModel(session: session, sceneReconstruction: sceneReconstructionProvider)
        self.virtualWorldModel = VirtualWorldModel()
        Task {
            await self.requestAuthorization()
        }
        Task {
            await self.virtualWorldModel.loadVirtualWorld()
        }
    }
    
    /// Requests the necessary authorizations for using hand tracking and world sensing features.
    /// This method asynchronously requests user permissions for hand tracking and world sensing capabilities essential for application functionalities.
    /// It logs the authorization status for each feature, which can be `allowed`, `denied`, or `notDetermined`.
    func requestAuthorization() async {
        let authorizationResult = await session.requestAuthorization(for: [.worldSensing, .handTracking])
        for (authorizationType, authorizationStatus) in authorizationResult {
            print("Authorization status for \(authorizationType): \(authorizationStatus)")
            switch authorizationStatus {
            case .allowed:
                // Authorized
                break
            case .denied:
                // Handle denial
                break
            case .notDetermined:
                // Undetermined state
                break
            @unknown default:
                // Handle future unknown cases
                break
            }
        }
    }

    /// Starts the AR session with configured providers if hand tracking is supported.
    /// This asynchronous method attempts to run the AR session using the `sceneReconstructionProvider` and `handTrackingProvider`.
    /// It logs an error message if starting the session fails.
    func runSession() async {
        do {
            if HandTrackingProvider.isSupported {
                print("ARKitSession starting.")
                try await session.run([sceneReconstructionProvider, handTrackingProvider])
            }
        } catch {
            print("ARKitSession error:", error)
        }
    }

}
