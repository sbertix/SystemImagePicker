//
//  CellWidthPreferenceKey.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining the size for any given cell system image.
struct CellWidthPreferenceKey: PreferenceKey {
    static let defaultValue: [String: CGFloat] = [:]
    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}

/// A `struct` defining the size for any given cell system image.
private struct CellWidthEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

extension EnvironmentValues {
    /// The size of any given cell system image.
    var cellWidth: CGFloat? {
        get { self[CellWidthEnvironmentKey.self] }
        set { self[CellWidthEnvironmentKey.self] = newValue }
    }
}
