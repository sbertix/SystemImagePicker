//
//  EmptyState.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining the empty state for the
/// system image picker.
struct EmptyState: View {
    /// The current search term.
    let query: String

    /// The underlying view.
    var body: some View {
        // Adapt the empty state to the query.
        if #available(iOS 17, macOS 14, watchOS 10, tvOS 17, *) {
            if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ContentUnavailableView.search(text: query)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ContentUnavailableView(
                    "No symbol found",
                    systemImage: "exclamationmark.triangle.fill",
                    description: Text("Check your data source.")
                ).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            VStack(spacing: 0) {
                let isSearching = !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                Image(systemName: isSearching ? "magnifyingglass" : "exclamationmark.triangle.fill")
                    .imageScale(.large)
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                Text(isSearching ? "No results for \"\(query)\"" : "No symbol found")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 4)
                Text(isSearching ? "Check the spelling or try a new search." : "Check your data source.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
