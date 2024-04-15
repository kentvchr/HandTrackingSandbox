//
//  SIMD4Extension.swift
//  HandTrackingSandbox
//
//  Created by Quentin Verchère on 10/03/2024.
//

import Foundation

extension SIMD4 {
    /// Extracts the xyz components from a SIMD4 vector as a SIMD3 vector.
    /// - Returns: A new SIMD3 containing the x, y, and z components of this SIMD4 vector.
    /// This property allows easy access to the first three elements of the SIMD4 vector, which is particularly useful
    /// in graphics programming where operations often need to manipulate just the spatial coordinates excluding the w-component.
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}
