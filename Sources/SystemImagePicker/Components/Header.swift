//
//  Header.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining the picker header for quickly
/// jumping between selection.
struct Header<Value: Hashable>: View {
    /// Whether it's searching or not.
    @Environment(\.isSearching) private var isSearching
    /// The pixel length.
    @Environment(\.pixelLength) private var pixelLength

    /// The current filter.
    @Binding var selection: String

    /// All available data.
    let data: SystemImageCollection<Value>

    /// The underlying view.
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(data.keys) { section in
                        // Whether it's selected or not.
                        let isSelected = section.id == selection
                        // The actual content.
                        Button {
                            // If it's already selected do nothing.
                            guard section.id != selection else { return }
                            selection = section.id
                        } label: {
                            HStack {
                                if let systemImage = section.systemImage {
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
                                    Text(section.title)
                                    // Add a small badge.
                                    if let values = data.values[section.id], !values.isEmpty {
                                        Text("\(values.count)")
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
                        }.buttonStyle(.plain)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                #if os(iOS)
                .padding(.top, isSearching ? 8 : 0)
                #elseif compiler(>=5.9) && os(visionOS)
                .padding(.vertical, 8)
                #endif
            }
            // Make sure the selected button is centered.
            .onAppear { scrollView.scrollTo(selection, anchor: .center) }
        }
    }
}
