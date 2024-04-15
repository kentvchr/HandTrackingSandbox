//
//  HandTrackingModel.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 25/02/2024.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI

/// `HandTrackingModel` manages the tracking of hand positions using ARKit.
///
/// This class encapsulates the functionality needed to track hand movements.
/// It processes updates from a hand tracking provider, handling the addition, updating, or removal of hands.
///
/// Properties:
/// - `session`: An ARKit session that manages the AR features and tracking.
/// - `handTracking`: A provider that delivers hand tracking updates.
/// - `leftHand`: A model representing the left hand, if detected.
/// - `rightHand`: A model representing the right hand, if detected.
///
/// Methods:
/// - init(session:handTracking:): Initializes the model with specified ARKit session and hand tracking provider.
///   It sets up the environment needed for tracking hands in an AR session.
/// - processHandUpdates(): Monitors and processes hand tracking updates asynchronously. It listens for changes reported by the hand tracking system and manages hand model instances accordingly:
///   - `added`: Detects and initializes a new `HandModel` for newly tracked hands, either left or right, and prints their discovery.
///   - `updated`: Receives updated tracking data for previously detected hands and refreshes their models.
///   - `removed`: Handles the event when a hand is no longer tracked, logging the loss of tracking.
///
/// This class uses `@MainActor` to ensure that all updates are processed on the main thread, suitable for updates
/// to UI or scene content in SwiftUI.


@Observable
@MainActor class HandTrackingModel {

    private let session: ARKitSession
    private let handTracking: HandTrackingProvider
    
    public var leftHand: HandModel?
    public var rightHand: HandModel?
    
    
    /// Initializes a new instance of the hand tracking model.
    ///
    /// This constructor sets up the hand tracking system with an ARKit session and a hand tracking provider.
    /// - Parameters:
    ///   - session: The ARKit session that manages the AR features and tracking.
    ///   - handTracking: The provider that handles hand tracking updates .
    init(session: ARKitSession, handTracking: HandTrackingProvider) {
        self.session = session
        self.handTracking = handTracking
    }
    
    /// Asynchronously processes hand tracking updates from the hand tracking anchor stream.
    ///
    /// This function listens for updates related to hand tracking in AR. It handles three types of events:
    /// - `added`: Initializes a new `HandModel` when a new hand (left or right) is detected.
    /// - `updated`: Updates the existing `HandModel` for the detected left or right hand with new tracking data.
    /// - `removed`: Logs the loss of tracking for a hand.
    func processHandUpdates() async {
        for await update in handTracking.anchorUpdates {
            let anchor = update.anchor
            switch update.event {
            case .added:
                print("Found \(update.anchor.chirality) Hand Tracking")
                switch anchor.chirality {
                case .left:
                    leftHand = HandModel(anchor)
                case .right:
                    rightHand = HandModel(anchor)
                }
            case .updated:
                switch anchor.chirality {
                case .left:
                    leftHand?.update(anchor)
                case .right:
                    rightHand?.update(anchor)
                }
            case .removed:
                // TO DO: Find when this is triggered
                print("Lost \(update.anchor.chirality) Hand Tracking")
            }
        }
    }
}
