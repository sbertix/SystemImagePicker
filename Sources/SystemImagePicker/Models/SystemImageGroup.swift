//
//  SystemImageGroup.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation

/// A `struct` defining a subset of all _SF Symbols_.
public struct SystemImageGroup: Codable, Hashable {
    /// The collection name.
    ///
    /// - note: When using custom `SystemImageGroup`s you MUST make sure their `name`s are unique.
    public let name: String

    /// The system image linked to the group.
    public let systemImage: String

    /// A collection of _SF Symbol_ identifiers.
    public let symbols: [String]

    /// Init.
    ///
    /// - parameters:
    ///     - name: The collection name.
    ///     - systemImage: The system image linked to the group.
    ///     - symbols: The _SF Symbol_ identifier.
    /// - note: When using custom `SystemImageGroup`s you MUST make sure their `name`s are unique.
    public init(name: String, systemImage: String, symbols: [String]) {
        self.name = name
        self.systemImage = systemImage
        self.symbols = symbols
    }
}

public extension SystemImageGroup {
    /// Load all _SF Symbols_ sections, depending on the
    /// current deployment target.
    static let allCases: [SystemImageGroup] = {
        let bundle: Bundle = .module
        // Target the valid `.json` file, depending
        // on the supported deployment target.
        let url: URL?
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
            url = bundle.url(forResource: "symbols5", withExtension: "json")
        } else if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            url = bundle.url(forResource: "symbols4", withExtension: "json")
        } else {
            fatalError("Unsupported OS version.")
        }
        // Load all sections.
        guard let url,
              let data: Data = try? .init(contentsOf: url),
              let groups = try? JSONDecoder().decode([SystemImageGroup].self, from: data) else {
            return []
        }
        return groups
    }()
}

extension SystemImageGroup: Identifiable {
    /// Groups use their name as identifier.
    ///
    /// - note: When using custom `SystemImageGroup`s you MUST make sure their `name`s are unique.
    public var id: String { name }
}
