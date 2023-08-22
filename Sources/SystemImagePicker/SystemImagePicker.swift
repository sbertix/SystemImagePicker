//
//  SystemImagePicker.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining a picker utility to select
/// a _SF Symbol_ within a collection.
public struct SystemImagePicker<Selection: Hashable, Value: Hashable>: View {
    /// The dismiss button.
    @Environment(\.dismiss) private var dismiss

    /// Whether it should auto-dismiss on selection or not.
    @Environment(\.systemImagePickerShouldAutoDismiss) private var shouldAutoDismiss
    /// The current layout style.
    @Environment(\.systemImagePickerStyle) private var style

    /// The active section filter.
    @State private var filter: String
    /// The search query.
    @State private var query: String = ""
    /// The current selection.
    @State private var selection: Selection

    /// The collection of symbols being displayed.
    private let data: SystemImageCollection<Value>
    /// A function to extract an optional system image identifier from a given selection.
    private let id: (Selection) -> String?
    /// The initial selection.
    private let initialSelection: Selection
    /// The transformation between `Value` and `Selection`, implemented for optionals.
    private let value: (Value) -> Selection

    /// The action tasked with syncing the internal state with the original binding.
    ///
    /// - note:
    ///     We use this approach to avoid useless rerendering on same value binding updates,
    ///     and provide the "undo"-like functionality when `shouldAutoDismiss` is off.
    private let onCommit: (Selection) -> Void

    /// The action tasked with invalidating the current selection, if it exists.
    ///
    /// - note:
    ///     We use this approach to support `Optional` `Selection`s without having
    ///     to specifically adjust the code for them (meaning it could be just as easily extended
    ///     to other situations).
    private let onInvalidate: (() -> Selection)?

    /// Filtered data.
    private var filteredData: SystemImageCollection<Value> {
        // No query, no filtering.
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return data }
        // Decide whether filtering using "dot notation"
        // (e.g. `circle.fill`) or "human-readable notation"
        // (e.g. `circle fill`) based on the query containing `.`.
        let isHumanReadable = !query.contains(".")
        let words = isHumanReadable ? query.split(separator: " ").map(\.localizedLowercase) : []
        // Check for each individual section.
        return data.filter {
            $1.filter {
                let id = $0[keyPath: data.id]
                print(isHumanReadable, id, words, words.allSatisfy(id.localizedStandardContains))
                return isHumanReadable
                    ? words.allSatisfy(id.localizedStandardContains)
                    : id.localizedStandardContains(query)
            }
        }
    }

    /// The underlying view.
    public var body: some View {
        let data = filteredData
        let selectionSystemImage = id(selection)
        let idealWidth = style.cellIdealWidth

        // The actual content.
        Wrapper {
            VStack(spacing: 0) {
                // Add the searchbar on macOS.
                #if os(macOS)
                HStack {
                    TextField("Search", text: $query)
                        .textFieldStyle(.plain)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        defer { dismiss() }
                        // If auto-dismiss is off, do not commit changes.
                        guard shouldAutoDismiss else { return }
                        onCommit(selection)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 16.0, height: 16.0)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.borderless)
                }
                .padding()
                #endif
                // The _SF Symbols_ grid.
                if data.values.isEmpty {
                    EmptyState(query: query)
                } else {
                    // A scrollable quick-jump to filter a
                    // specific section.
                    Header(selection: $filter, data: data)
                    #if compiler(<5.9) || !os(visionOS)
                    Divider()
                        #if !os(macOS)
                        .padding([.leading, .top])
                        #else
                        .padding(.top)
                        #endif
                    #endif
                    ScrollViewReader { scrollView in
                        ScrollView {
                            LazyVGrid(columns: [.init(.adaptive(
                                minimum: idealWidth / 1.1,
                                maximum: idealWidth * 1.1
                            ))]) {
                                // Enumerate the values.
                                ForEach(data.values[filter] ?? [], id: \.self) {
                                    Cell(
                                        selectionSystemImage: selectionSystemImage,
                                        value: $0,
                                        id: data.id
                                    ) {
                                        let newSelection = value($0)
                                        // If it's the same value, either invalidate
                                        // it (e.g. toggle it off) or do nothing.
                                        if newSelection == selection {
                                            guard let onInvalidate else { return }
                                            selection = onInvalidate()
                                        } else {
                                            selection = newSelection
                                        }
                                        guard shouldAutoDismiss else { return }
                                        // Immediately reflect the selection and
                                        // dismiss the view.
                                        onCommit(selection)
                                        dismiss()
                                    }
                                }
                            }
                            .animation(.none, value: query.isEmpty)
                            .animation(.none, value: selection)
                            .modifier(PreferenceToEnvironmentModifier(
                                \.cellWidth,
                                reflecting: CellWidthPreferenceKey.self
                            ) {
                                $0.values.max()
                            })
                            .padding()
                        }
                        .onAppear {
                            // Scroll to the top.
                            scrollView.scrollTo(
                                data.values[filter]?.first.flatMap { $0[keyPath: data.id] },
                                anchor: .topLeading
                            )
                            // Scroll to selection, if it's in view.
                            scrollView.scrollTo(selectionSystemImage, anchor: .center)
                        }
                        .id("scroll-\(filter)")
                    }
                }
            }
            #if os(iOS) || (compiler(>=5.9) && os(visionOS))
            .background(Color(.systemGroupedBackground))
            #else
            .background()
            #endif
            .background(ignoresSafeAreaEdges: .all)
            #if os(iOS) || (compiler(>=5.9) && os(visionOS))
            .searchable(
                text: $query,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            #endif
            .safeAreaInset(edge: .bottom) {
                    // Let users invalidate their symbol
                    // without having to find it and toggle it.
                    if let onInvalidate, let systemImage = id(selection) {
                        Button(role: .destructive) {
                            selection = onInvalidate()
                            guard shouldAutoDismiss else { return }
                            // Immediately reflect the selection and
                            // dismiss the view.
                            onCommit(selection)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: systemImage)
                                    .font(.headline)
                                    .imageScale(.small)
                                Text("Deselect Symbol")
                                    .font(.headline.smallCaps())
                                    .padding(.top, 8)
                                    .padding(.bottom, 10)
                                Image(systemName: "xmark")
                                    .imageScale(.small)
                                    .font(.footnote.bold())
                                    .foregroundStyle(.secondary)
                            }
                            .lineLimit(1)
                            .fixedSize()
                            .padding(.horizontal, 12)
                            #if compiler(<5.9) || !os(visionOS)
                            .background(.tint, in: RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            #else
                            .background(.regularMaterial, in: Capsule())
                            .contentShape(Capsule())
                            #endif
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.red)
                        .tint(.red.opacity(0.15))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.bar)
                        .overlay(Divider(), alignment: .top)
                    }
                }
                #if !os(macOS)
                .toolbar {
                    // The dismiss button.
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) {
                            defer { dismiss() }
                            // If auto-dismiss is off, do not commit changes.
                            guard shouldAutoDismiss else { return }
                            onCommit(selection)
                        }
                    }
                    // Only add the "Done" button when auto-dismiss is off.
                    ToolbarItem(placement: .confirmationAction) {
                        if !shouldAutoDismiss {
                            Button("Done") {
                                onCommit(selection)
                                dismiss()
                            }.disabled(initialSelection == selection)
                        }
                    }
                }
                #endif
                // With `shouldAutoDismiss` set to off and changes
                // being made, disable drag down to dismiss so the
                // user has to explicitly pick whether to discard
                // or confirm the selection.
                .interactiveDismissDisabled(!shouldAutoDismiss && initialSelection != selection)
        }
    }

    /// Init.
    ///
    /// - parameters:
    ///     - selection: The selected _SF Symbol_ representation binding.
    ///     - data: A collection of _SF Symbol_ representations to pick from.
    ///     - id: The _SF Symbol_ identifier transformation.
    ///     - value: The `Value` to `Selection` transformation.
    ///     - onInvalidate: An optional invalidation.
    init(
        selection: Binding<Selection>,
        data: SystemImageCollection<Value>,
        id: @escaping (Selection) -> String?,
        value: @escaping (Value) -> Selection,
        onInvalidate: (() -> Selection)?
    ) {
        self._selection = .init(initialValue: selection.wrappedValue)
        self.data = data
        self.id = id
        self.initialSelection = selection.wrappedValue
        self.value = value
        self.onCommit = { selection.wrappedValue = $0 }
        self.onInvalidate = onInvalidate

        // Populate the filter based on current selection.
        // If the selection is invalid, go with the first section.
        self._filter = .init(initialValue: id(selection.wrappedValue).flatMap { selection in
            data.values.first { $0.value.first { $0[keyPath: data.id] == selection } != nil }
        }?.key ?? data.keys.first?.id ?? "")
    }
}

public extension SystemImagePicker where Selection == Value {
    /// Init.
    ///
    /// - parameters:
    ///     - selection: The selected _SF Symbol_ representation binding.
    ///     - data: A collection of _SF Symbol_ representations to pick from.
    init(selection: Binding<Selection>, data: SystemImageCollection<Value>) {
        self.init(
            selection: selection,
            data: data,
            id: { $0[keyPath: data.id] },
            value: { $0 },
            onInvalidate: nil
        )
    }

    /// Init.
    ///
    /// - parameter selection: The selected _SF Symbol_ representation binding.
    init(selection: Binding<Selection>) where Value == String {
        self.init(selection: selection, data: .default)
    }

    /// Init.
    ///
    /// - parameter selection: The selected _SF Symbol_ representation binding.
    init(selection: Binding<Selection>) where Value: RawRepresentable, Value.RawValue == String {
        self.init(selection: selection, data: .default)
    }
}

public extension SystemImagePicker where Selection == Value? {
    /// Init.
    ///
    /// - parameters:
    ///     - selection: The selected _SF Symbol_ representation binding.
    ///     - data: A collection of _SF Symbol_ representations to pick from.
    init(selection: Binding<Selection>, data: SystemImageCollection<Value>) {
        self.init(
            selection: selection,
            data: data,
            id: { $0?[keyPath: data.id] },
            value: { $0 },
            onInvalidate: { nil }
        )
    }

    /// Init.
    ///
    /// - parameter selection: The selected _SF Symbol_ representation binding.
    init(selection: Binding<Selection>) where Value == String {
        self.init(selection: selection, data: .default)
    }

    /// Init.
    ///
    /// - parameter selection: The selected _SF Symbol_ representation binding.
    init(selection: Binding<Selection>) where Value: RawRepresentable, Value.RawValue == String {
        self.init(selection: selection, data: .default)
    }
}
