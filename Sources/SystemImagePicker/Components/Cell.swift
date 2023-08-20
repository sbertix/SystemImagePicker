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
    /// The ideal width for the _SF Symbol_ cell.
    static var idealWidth: CGFloat {
        #if os(iOS)
        64
        #elseif os(macOS)
        48
        #elseif os(tvOS)
        128
        #elseif compiler(>=5.9) && os(visionOS)
        64
        #else
        48
        #endif
    }

    /// The pixel length.
    @Environment(\.pixelLength) private var pixelLength
    /// The cell icon width.
    @Environment(\.cellWidth) private var cellWidth
    /// Whether it should auto-dismiss on selection or not.
    @Environment(\.systemImagePickerShouldAutoDismiss) private var shouldAutoDismiss

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
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: cellWidth, height: cellWidth)
                .background {
                    GeometryReader {
                        // Track the dynamic width of the grid item
                        // so we can make it square.
                        Color.clear.preference(
                            key: CellWidthPreferenceKey.self,
                            value: [systemImage: $0.size.width]
                        )
                    }
                }
                #if os(iOS)
                .background(selectionSystemImage == systemImage ? Color.accentColor : .init(.secondarySystemGroupedBackground))
                .foregroundStyle(selectionSystemImage == systemImage ? Color(.secondarySystemGroupedBackground) : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .contentShape(RoundedRectangle(cornerRadius: 8))
                #elseif compiler(>=5.9) && os(visionOS)
                .background(
                    selectionSystemImage == systemImage ? AnyShapeStyle(.regularMaterial) : AnyShapeStyle(.clear),
                    in: RoundedRectangle(cornerRadius: 8)
                )
                #elseif os(macOS)
                .background(selectionSystemImage == systemImage ? Color(.windowBackgroundColor) : .clear)
                .foregroundStyle(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    selectionSystemImage == systemImage
                        ? RoundedRectangle(cornerRadius: 8).strokeBorder(Color(.separatorColor), lineWidth: pixelLength)
                        : nil
                )
                .contentShape(RoundedRectangle(cornerRadius: 8))
                #else
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .contentShape(RoundedRectangle(cornerRadius: 8))
                #endif
        }
        .buttonStyle(.plain)
        .animation(.none, value: cellWidth)
    }
}
