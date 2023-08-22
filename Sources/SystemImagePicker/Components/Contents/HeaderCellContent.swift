//
//  HeaderCellContent.swift
//
//
//  Created by Stefano Bertagno on 22/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining the content of a header cell.
public struct HeaderCellContent: View {
    /// The pixel length.
    @Environment(\.pixelLength) private var pixelLength
    
    /// The section name.
    let title: String
    /// The _SF Symbol_ identifier, if it exists.
    let systemImage: String?
    /// Whether it's selected or not.
    let isSelected: Bool
    /// The amount of items inside the section.
    let count: Int

    /// The underlying view.
    public var body: some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.headline)
                    #if os(iOS)
                    .foregroundStyle(isSelected ? .secondary : .primary)
                    .foregroundStyle(isSelected ? Color(.secondarySystemGroupedBackground) : .accentColor)
                    #elseif os(macOS)
                    .foregroundStyle(.tint)
                    #elseif compiler(>=5.9) && os(visionOS)
                    .foregroundStyle(.secondary)
                    #endif
                    .imageScale(.small)
            }
            HStack {
                Text(title)
                // Add a small badge.
                if count > 0 {
                    Text("\(count)")
                        .foregroundStyle(isSelected ? .secondary : .tertiary)
                        .monospacedDigit()
                }
            }
            .font(.headline.smallCaps())
            .padding(.top, 8)
            .padding(.bottom, 10)
        }
        .lineLimit(1)
        .fixedSize()
        .padding(.horizontal, 12)
        #if os(iOS)
        .background(isSelected ? Color.accentColor : .init(.secondarySystemGroupedBackground))
        .foregroundStyle(isSelected ? Color(.secondarySystemGroupedBackground) : .primary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(RoundedRectangle(cornerRadius: 8))
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
        #elseif compiler(>=5.9) && os(visionOS)
        .background(
            isSelected
                ? AnyShapeStyle(.regularMaterial)
                : AnyShapeStyle(.clear),
            in: RoundedRectangle(cornerRadius: 8)
        )
        #else
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(RoundedRectangle(cornerRadius: 8))
        #endif
    }
}
