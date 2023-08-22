//
//  CellContent.swift
//
//
//  Created by Stefano Bertagno on 22/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining the content of a _SF Symbol_ cell.
public struct CellContent: View {
    /// The pixel length.
    @Environment(\.pixelLength) private var pixelLength
    /// The cell icon width.
    @Environment(\.cellWidth) private var cellWidth
    /// The current layout style.
    @Environment(\.systemImagePickerStyle) private var style

    /// The _SF Symbol_ identifier.
    let systemImage: String
    /// Whether it's selected or not.
    let isSelected: Bool

    /// The underlying view.
    public var body: some View {
        Image(systemName: systemImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .frame(width: cellWidth, height: style.cellHeight ?? cellWidth)
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
            .background(isSelected ? Color.accentColor : .init(.secondarySystemGroupedBackground))
            .foregroundStyle(isSelected ? Color(.secondarySystemGroupedBackground) : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
            #elseif os(watchOS)
            .background(isSelected ? Color.accentColor : .clear)
            .foregroundStyle(isSelected ? AnyShapeStyle(.background) : AnyShapeStyle(.primary))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
            #elseif compiler(>=5.9) && os(visionOS)
            .background(
                isSelected ? AnyShapeStyle(.regularMaterial) : AnyShapeStyle(.clear),
                in: RoundedRectangle(cornerRadius: 8)
            )
            #elseif os(macOS)
            .background(isSelected ? Color(.windowBackgroundColor) : .clear)
            .foregroundStyle(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                isSelected
                    ? RoundedRectangle(cornerRadius: 8).strokeBorder(Color(.separatorColor), lineWidth: pixelLength)
                    : nil
            )
            .contentShape(RoundedRectangle(cornerRadius: 8))
            #else
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
            #endif
    }
}
