//
//  Hand.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 10/03/2024.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI

/// Represents a model of a hand in an augmented reality environment using ARKit.
///
/// This class manages the representation of a hand (either left or right) using ARKit's `HandAnchor` to track movement and orientation. It maintains a collection of `ModelEntity` objects, each corresponding to a joint in the hand skeleton.
///
/// - Properties:
///   - anchor: The current `HandAnchor` providing tracking data for the hand.
///   - chirality: Indicates whether the hand is left or right.
///   - entity: The root `Entity` that groups all joint entities.
///   - jointEntities: A dictionary mapping each joint name to a `ModelEntity`.
///
/// - Methods:
///   - init(_:): Initializes the hand model with a `HandAnchor`.
///   - update(_:): Updates the model based on new `HandAnchor` data. If the hand is no longer tracked, it clears all entities.
///   - clearAllEntities(): Removes all joint entities from their parent, effectively clearing the visual representation.
///

class HandModel {
    
    private var anchor: HandAnchor
    private let chirality: HandAnchor.Chirality
    public var entity: Entity
    private var jointEntities: [HandSkeleton.JointName: ModelEntity]
    
    /// Initializes a new HandModel using a HandAnchor.
    ///
    /// This constructor sets up a HandModel with an anchor representing either the left or right hand.
    /// It initializes an empty entity to represent the hand in a scene and a dictionary to hold the joint entities.
    /// Each joint of the hand is then assigned a cube representation colored according to the hand's chirality.
    ///
    /// - Parameter anchor: The `HandAnchor` used to initialize the model, providing details like chirality and initial joint positions.
    init(_ anchor: HandAnchor) {
        self.anchor = anchor
        self.chirality = anchor.chirality
        self.entity = Entity()
        self.jointEntities = [:]
        HandSkeleton.JointName.allCases.forEach { jointName in
            jointEntities[jointName] = ModelEntity.createFingerJointCube(color: anchor.chirality.color)
        }
    }
    
    /// Updates the hand model based on the latest tracking data provided by a `HandAnchor`.
    ///
    /// This method updates the model using new data from the ARKit `HandAnchor`. It performs several checks:
    /// - Confirms that the anchor is still being tracked and that the hand skeleton data is available.
    /// - Iterates through all joints in the hand skeleton.
    ///   - If a joint is no longer tracked, its associated entity is removed from the parent.
    ///   - If an entity for a joint doesn't currently have a parent, it is added to the root entity.
    ///   - The transformation matrix for each joint's entity is updated based on its new position and orientation relative to the anchor.
    ///
    /// Entities are cleared if the hand is no longer tracked or if skeleton data is unavailable.
    func update(_ anchor: HandAnchor) {
        self.anchor = anchor
        guard anchor.isTracked, let skeleton = self.anchor.handSkeleton else {
            clearAllEntities()
            return
        }
        for skeletonJoint in skeleton.allJoints {
            guard let jointEntity = jointEntities[skeletonJoint.name] else { continue }
            guard skeletonJoint.isTracked else {
                jointEntity.removeFromParent()
                continue
            }
            if jointEntity.parent == nil {
                self.entity.addChild(jointEntity)
            }
            let transformMatrix = matrix_multiply(self.anchor.originFromAnchorTransform, skeletonJoint.anchorFromJointTransform)
            jointEntity.setTransformMatrix(transformMatrix, relativeTo: nil)
        }
    }
    
    /// Removes all joint entities from their parent entity.

    private func clearAllEntities() {
        HandSkeleton.JointName.allCases.forEach { jointName in
            if let modelEntity = jointEntities[jointName] {
                modelEntity.removeFromParent()
            }
        }
    }
}
