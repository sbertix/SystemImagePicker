//
//  SystemImagePickerStyleEnvironmentKey.swift
//
//
//  Created by Stefano Bertagno on 22/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining an environment key tracking the
/// system image picker preferred layout style.
public struct SystemImagePickerStyleEnvironmentKey: EnvironmentKey {
    /// Defaults to `nil`, meaning `DefaultSystemImagePickerStyle` will be used.
    public static var defaultValue: AnySystemImagePickerStyle = .init(.default)
}

extension EnvironmentValues {
    /// The system image picker preferred layout style.
    fileprivate(set) var systemImagePickerStyle: AnySystemImagePickerStyle {
        get { self[SystemImagePickerStyleEnvironmentKey.self] }
        set { self[SystemImagePickerStyleEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Update the preferred system image picker layout style.
    ///
    /// - parameter style: Some `SystemImagePickerStyle`.
    /// - returns: Some `View`.
    func systemImagePickerStyle(_ style: some SystemImagePickerStyle) -> some View {
        environment(\.systemImagePickerStyle, .init(style))
    }
}
