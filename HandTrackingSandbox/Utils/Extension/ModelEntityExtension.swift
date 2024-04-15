//
//  ModelEntityExtension.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 28/02/2024.
//

import Foundation
import SwiftUI
import RealityKit

extension ModelEntity {
    /// Creates a cube intended to represent a finger joint. This method configures the cube with specific physical and visual properties.
    /// - Parameter color: The color of the cube, typically reflecting the associated hand's chirality.
    /// - Returns: A `ModelEntity` configured as a small cube with specified color and kinematic physics properties.
    class func createFingerJointCube(color: UIColor) -> ModelEntity {
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.01, cornerRadius: 0),
            materials: [UnlitMaterial(color: color)],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.001)),
            mass: 0.1
        )
        entity.components.set(PhysicsBodyComponent(mode: .kinematic))
        entity.components.set(OpacityComponent(opacity: 1))
        return entity
    }
    
    /// Creates a standard cube with random coloration and dynamic physical properties.
    /// - Returns: A `ModelEntity` with dynamic physics settings, suitable for interactive AR environments.
    class func createCube() -> ModelEntity {
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.1, cornerRadius: 0),
            materials: [SimpleMaterial(color: UIColor.random(), isMetallic: false)],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.1)),
            mass: 1.0
        )
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0)
        entity.components.set(
            PhysicsBodyComponent(
                shapes: entity.collision!.shapes,
                mass: 1.0,
                material: material,
                mode: .dynamic
            )
        )
        return entity
    }
}

