//
//  SystemImageSection.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 22/08/23.
//

import Foundation

/// A `struct` defining a picker section.
public struct SystemImageSection: Codable, Hashable, Identifiable {
    /// The name.
    public let title: String
    /// The optional system image.
    public let systemImage: String?

    /// The section identifier.
    public var id: String { title }

    /// Init.
    ///
    /// - parameters:
    ///     - title: The name used to identify the section.
    ///     - systemImage: An optional _SF Symbol_ identifier.
    public init(title: String, systemImage: String?) {
        self.title = title
        self.systemImage = systemImage
    }
}
