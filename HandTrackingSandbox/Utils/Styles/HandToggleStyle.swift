//
//  HandToggleStyle.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 02/03/2024.
//

import Foundation
import SwiftUI
import ARKit

/// A custom `ToggleStyle` for SwiftUI that creates a toggle button with a hand symbol.
/// This style adapts the appearance of the toggle based on the chirality (left or right hand) and toggle state.
///
/// Properties:
/// - `chirality`: Determines the hand orientation (left or right) for the toggle button.
///
/// Behavior:
/// - The toggle button displays a hand symbol.
/// - The hand symbol fills when the toggle is in the 'on' state and is outlined when 'off'.
/// - The color of the filled hand changes based on the chirality and toggle state.
/// - A text label displays the chirality capitalized below the symbol.
struct HandToggleStyle: ToggleStyle {
    
    var chirality: HandAnchor.Chirality
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            VStack {
                Image(systemName: configuration.isOn ? "hand.raised.fill" : "hand.raised")
                    .imageScale(.large)
                    .font(.largeTitle)
                    .scaleEffect(x: chirality == .right ? -1 : 1)
                    .foregroundStyle(configuration.isOn ? Color(chirality.color) : .gray)
                Text(chirality.id.capitalized)
                    .frame(width: 64)
            }
            .padding()
        }
        .frame(height: 96)
        .clipShape(Circle())
        .buttonStyle(.plain)
    }
}
