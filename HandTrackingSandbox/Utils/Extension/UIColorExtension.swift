//
//  UIColorExtension.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 05/04/2024.
//

import Foundation
import SwiftUI

extension UIColor {
    /// Returns a random color.
    /// This static method selects a random color from a predefined set of colors including green, blue, purple, and black.
    /// If no color is selected due to an (very) unexpected error, white is returned as a default.
    ///
    /// - Returns: A `UIColor` object that is randomly chosen from the specified set of colors.
    static func random() -> UIColor {
        let colors: [UIColor] = [.green, .blue, .purple, .black]
        return colors.randomElement() ?? .white
    }
}
