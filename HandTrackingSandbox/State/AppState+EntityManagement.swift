//
//  AppState+EntityManagement.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 28/02/2024.
//

import Foundation
import RealityKit

extension AppState {
    /// Adds an entity to the scene's root entity if the entity is not nil.
    ///
    /// - Parameter entity: The `Entity` to be added to the scene.
    public func addEntityToScene(_ entity: Entity?) {
        guard let entity = entity else {
            return
        }
        rootEntity.addChild(entity)
    }

    /// Removes an entity from its parent in the scene hierarchy if the entity is not nil.
    ///
    /// - Parameter entity: The `Entity` to be removed from its parent.
    public func removeEntityFromScene(_ entity: Entity?) {
        guard let entity = entity else {
            return
        }
        entity.removeFromParent()
    }

    /// Spawns a cube at a specified location, offset by predefined distances on the y and z axes.
    ///
    /// The cube is placed 20 centimeters above and 20 centimeters forward relative to the given tap location.
    /// - Parameter tapLocation: The `SIMD3<Float>` coordinates where the tap occurred.
    func spawnCube(tapLocation: SIMD3<Float>) {
        // Set the spawn location 20 centimeters above and 40 centimenters beyond the tap.
        let placementLocation = tapLocation + SIMD3<Float>(0, 0.2, -0.4)
        let entity = ModelEntity.createCube()
        entity.setPosition(placementLocation, relativeTo: nil)
        self.rootEntity.addChild(entity)
    }

}
