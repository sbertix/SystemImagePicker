//
//  PreferenceToEnvironmentModifier.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation
import SwiftUI

/// A `struct` applying a preference key
/// directly to an environment, without causing
/// unnecessary re-renderings.
struct PreferenceToEnvironmentModifier<
    Value: Equatable,
    PreferenceKey: SwiftUI.PreferenceKey
>: ViewModifier where PreferenceKey.Value: Equatable {
    /// The preference value.
    @State private var value: Value
    /// The environment key path.
    private let keyPath: WritableKeyPath<EnvironmentValues, Value>
    /// The value builder.
    private let transform: (PreferenceKey.Value) -> Value

    /// Init.
    init(
        _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
        reflecting _: PreferenceKey.Type,
        transform: @escaping (PreferenceKey.Value) -> Value
    ) {
        self._value = .init(initialValue: transform(PreferenceKey.defaultValue))
        self.keyPath = keyPath
        self.transform = transform
    }

    /// The underlying view.
    func body(content: Content) -> some View {
        content.onPreferenceChange(PreferenceKey.self) {
            let newValue = transform($0)
            guard newValue != value else { return }
            value = newValue
        }.environment(keyPath, value)
    }
}
