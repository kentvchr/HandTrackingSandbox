//
//  VirtualRealityModel.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 10/04/2024.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

/// Manages the 3D environment within a virtual reality experience, capable of loading RealityComposer scenes, skyboxes, and animating specific entities.
///
/// Properties:
/// - `contentEntity`: The root entity where all entities are attached.
/// - `isLoaded`: Indicates whether the virtual environment has been successfully loaded.
///
/// Initialization:
/// - `init()`: Initializes a new VirtualWorldModel with an empty root entity and sets `isLoaded` to false.
///
/// Methods:
/// - `loadVirtualWorld()`: Asynchronously loads the skybox, scene, and triggers animations for specific entities like 'BB8_Animated' and 'Raichu'.
/// - `loadSkybox()`: Asynchronously loads a textured skybox to create a starfield backdrop.
/// - `loadScene()`: Asynchronously loads a named scene from the RealityKit content bundle to enrich the AR experience.
/// - `animateEntity(_:)`: Animates a specified entity by name if it is found within the content entity.
///
@MainActor
class VirtualWorldModel {
    
    public var contentEntity: Entity
    public var isLoaded: Bool
    
    /// Initializes a new instance of VirtualWorldModel.
    ///
    /// This constructor sets up the model with a default empty root entity and marks the virtual world as not yet loaded.
    /// - `contentEntity`: Initializes as an empty `Entity`, serving as the root for all added AR content.
    /// - `isLoaded`: Set to `false` indicating that the virtual world content is not loaded initially.
    init() {
        self.contentEntity = Entity()
        self.isLoaded = false
    }
    
    /// Asynchronously loads the virtual world, including the skybox, the immersive scene, and animations for specified entities.
    func loadVirtualWorld() async {
        await loadSkybox()
        await loadScene()
        animateEntity("BB8_Animated")
        animateEntity("Raichu")
    }
    
    /// Asynchronously loads a textured skybox into the scene to create a starfield effect.
    /// Throws a fatal error if the texture resource is not available, indicating a critical failure.
    func loadSkybox() async {
        let skyboxEntity = Entity()
        guard let resource = try? await TextureResource(named: "Starfield") else {
            // If the asset isn't available, something is wrong with the app.
            fatalError("Unable to load starfield texture.")
        }
        var material = UnlitMaterial()
        material.color = .init(texture: .init(resource))
        
        skyboxEntity.components.set(ModelComponent(
            mesh: .generateSphere(radius: 1000),
            materials: [material]
        ))
        
        // Ensure the texture image points inward at the viewer.
        skyboxEntity.scale *= .init(x: -1, y: 1, z: 1)
        let angle = Angle.degrees(90)
        let rotation = simd_quatf(angle: Float(angle.radians), axis: SIMD3<Float>(0, 1, 0))
        skyboxEntity.transform.rotation = rotation
        self.contentEntity.addChild(skyboxEntity)
        self.isLoaded = true
    }
    
    /// Asynchronously loads a predefined scene named "Immersive" from the RealityKit content bundle.
    /// Throws a fatal error if the scene cannot be loaded.
    func loadScene() async {
        guard let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
            fatalError("Unable to load Immerive Scene from RealityKitContent")
        }
        self.isLoaded = true
        self.contentEntity.addChild(scene)
    }
    
    /// Animates a specified entity by name if it exists within the content entity.
    /// Does nothing if the entity cannot be found or the animation resource is unavailable.
    func animateEntity(_ entityName: String) {
        guard let entity = contentEntity.findEntity(named: entityName),
        let entityAnimResource = entity.availableAnimations.first,
        let entityAnim = try? AnimationResource.generate(with: entityAnimResource.repeat().definition)
        else { return }
        entity.playAnimation(entityAnim)
    }
}
