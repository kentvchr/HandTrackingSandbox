//
//  SceneReconstructionModel.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 27/03/2024.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI
import RealityKitContent

/// Manages the AR scene reconstruction process using ARKit's scene reconstruction features.
///
/// This class handles the ARKit session and updates related to scene reconstruction, managing a collection
/// of mesh entities that represent the physical environment's 3D geometry. It provides functionalities to
/// add, update, and remove meshes based on real-time updates from the AR environment.
///
/// - Properties:
///   - session: An `ARKitSession` object.
///   - sceneReconstruction: A `SceneReconstructionProvider` object that provides scene reconstruction data.
///   - meshEntities: A dictionary storing mesh entities with their UUIDs as keys.
///   - contentEntity: The root `Entity` that groups all mesh entities.
///
/// - Methods:
///   - init(session:sceneReconstruction:): Initializes the model with a session and scene reconstruction provider.
///   - processSceneReconstructionUpdates(): Asynchronously processes updates from the scene reconstruction provider,
///     handling the addition, update, or removal of mesh entities based on the scene data.
///
///
/// This class uses `@MainActor` to ensure that all updates are processed on the main thread, suitable for updates
/// to UI or scene content in SwiftUI.

@Observable
@MainActor class SceneReconstructionModel {
    
    private let session: ARKitSession
    private let sceneReconstruction: SceneReconstructionProvider
    
    private var meshEntities = [UUID: ModelEntity]()
    public var contentEntity = Entity()
    
    /// Initializes a new instance of the scene reconstruction model.
    ///
    /// This constructor sets up the scene reconstruction system with an ARKit session and a scene reconstruction provider.
    /// - Parameters:
    ///   - session: The ARKit session that manages the AR features and tracking.
    ///   - sceneReconstruction: The provider that handles scene reconstruction, providing updates on the environment's 3D geometry.
    init(session: ARKitSession, sceneReconstruction: SceneReconstructionProvider) {
        self.session = session
        self.sceneReconstruction = sceneReconstruction
    }
    
    /// Asynchronously processes updates from scene reconstruction, managing the lifecycle of mesh entities.
    ///
    /// This method listens for updates related to scene reconstruction, each tied to a mesh anchor. It performs operations based on the type of event:
    /// - `added`: Attempts to generate a static mesh from the mesh anchor. If successful, creates a new `ModelEntity`, configures its properties (transform, collision, physics), and adds it to the content entity.
    /// - `updated`: Updates the transform and collision shapes of existing entities based on the latest anchor information.
    /// - `removed`: Logs the loss of a mesh and removes the corresponding entity from the parent and the local storage.
    ///
    /// The method handles the dynamic addition, update, and removal of meshes as scene data changes.
    func processSceneReconstructionUpdates() async {
        for await update in sceneReconstruction.anchorUpdates {
            let meshAnchor = update.anchor
            guard let shape = try? await ShapeResource.generateStaticMesh(from: meshAnchor) else {
                continue
            }
            switch update.event {
            case .added:
                print("Found \(update.anchor.description) Scene Reconstruction")
                let entity = ModelEntity()
                entity.transform = Transform(matrix: meshAnchor.originFromAnchorTransform)
                entity.collision = CollisionComponent(shapes: [shape], isStatic: true)
                entity.physicsBody = PhysicsBodyComponent()
                // Entity can be a target for gesture:
                entity.components.set(InputTargetComponent())
                
                meshEntities[meshAnchor.id] = entity
                contentEntity.addChild(entity)
            case .updated:
                guard let entity = meshEntities[meshAnchor.id] else { fatalError("...") }
                entity.transform = Transform(matrix: meshAnchor.originFromAnchorTransform)
                entity.collision?.shapes = [shape]

            case .removed:
                print("Lost \(update.anchor.description) Scene Reconstruction")
                meshEntities[meshAnchor.id]?.removeFromParent()
                meshEntities.removeValue(forKey: meshAnchor.id)
            }
        }
    }
}
