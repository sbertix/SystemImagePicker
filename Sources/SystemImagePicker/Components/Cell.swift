//
//  Cell.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining the appearance of system
/// image cells inside of the picker.
struct Cell<Value: Hashable>: View {
    /// The cell icon width.
    @Environment(\.cellWidth) private var cellWidth
    /// Whether it should auto-dismiss on selection or not.
    @Environment(\.systemImagePickerShouldAutoDismiss) private var shouldAutoDismiss
    /// The current layout style.
    @Environment(\.systemImagePickerStyle) private var style

    /// The selection system image identifier.
    let selectionSystemImage: String?
    /// The current value.
    let value: Value
    /// The _SF Symbol_ identifier key path.
    let id: KeyPath<Value, String>
    /// The button action.
    let action: (Value) -> Void

    /// The underlying view.
    var body: some View {
        let systemImage = value[keyPath: id]

        // The actual content.
        Button {
            // We rely on action instead of binding
            // the selection value here so the
            // `shouldAutoDismiss` logic can stay inside
            // `SystemImagePicker`.
            action(value)
        } label: {
            style.cell(
                with: systemImage,
                isSelected: systemImage == selectionSystemImage
            )
        }
        .buttonStyle(.plain)
        .animation(.none, value: cellWidth)
    }
}
