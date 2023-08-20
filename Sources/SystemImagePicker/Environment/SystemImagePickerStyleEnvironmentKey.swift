//
//  SystemImagePickerStyleEnvironmentKey.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining an environment key used to track
/// whether the picker should auto-dismiss or not.
private struct SystemImagePickerShouldAutoDismissEnvironmentKey: EnvironmentKey {
    /// Defaults to auto-dismissing.
    public static let defaultValue: Bool = true
}

extension EnvironmentValues {
    /// The currently defined system image picker style.
    ///
    /// Defaults to `.default`.
    fileprivate(set) var systemImagePickerShouldAutoDismiss: Bool {
        get { self[SystemImagePickerShouldAutoDismissEnvironmentKey.self] }
        set { self[SystemImagePickerShouldAutoDismissEnvironmentKey.self] = newValue }
    }
}

public extension View {
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    /// Update wheter children system image pickers should auto-dismiss on selection or not.
    ///
    /// - parameter shouldAutoDismiss: Whether it should auto-dismiss on selection or not.
    /// - returns: Some `View`.
    func dismissOnSelection(_ shouldAutoDismiss: Bool) -> some View {
        environment(\.systemImagePickerShouldAutoDismiss, shouldAutoDismiss)
    }
}
