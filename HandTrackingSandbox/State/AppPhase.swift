//
//  AppPhase.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 25/02/2024.
//

import Foundation

/// Represents the main phases of the application's lifecycle.
///
/// `AppPhase` is an enumeration that indicates the current phase of the app.
/// Each phase corresponds to a distinct part of the app's user interface or functionality.
///
/// - Cases:
///   - home: Indicates that the app is in the home screen phase.
///   - immersion: Indicates that the app is in an immersive experience phase.
public enum AppPhase: String, Codable, Sendable, Equatable {
    case home
    case immersion
}

