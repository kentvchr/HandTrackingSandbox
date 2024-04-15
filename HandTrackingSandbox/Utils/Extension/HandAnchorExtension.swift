//
//  HandAnchorExtension.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 10/03/2024.
//

import Foundation
import ARKit
import SwiftUI

extension HandAnchor.Chirality {
    /// Provides a shorthand identifier for the chirality of a hand.
    /// - Returns: A string identifier where "r" represents right and "l" represents left.
    var id: String {
        switch self {
        case .right:
            return "r"
        case .left:
            return "l"
        }
    }
    
    /// Provides a color associated with the chirality of a hand.
    /// - Returns: Cyan for the right hand and red for the left hand.
    /// This property can be used to visually distinguish between the left and right hands in UI elements.
    var color: UIColor {
        switch self {
        case .right:
            return .cyan
        case .left:
            return .red
        }
    }
}
