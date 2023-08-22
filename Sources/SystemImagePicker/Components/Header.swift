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
    /// The current layout style.
    @Environment(\.systemImagePickerStyle) private var style

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
                        Button {
                            // If it's already selected do nothing.
                            guard section.id != selection else { return }
                            selection = section.id
                        } label: {
                            style.headerCell(
                                with: section.title,
                                systemImage: section.systemImage,
                                isSelected: section.id == selection,
                                count: data.values[section.id]?.count ?? 0
                            )
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
