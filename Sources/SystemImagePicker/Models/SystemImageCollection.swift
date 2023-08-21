//
//  SystemImageCollection.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation

/// A `struct` defining the main modal for the picker.
///
/// System image collection can only be constructed with:
/// - `String`s, representing the system image name.
/// - `Identifiable` instances of `String` `ID`, where `id` represents the system image name.
/// - `RawRepresentable` instances of `String` `RawValue`, where `rawValue` represents the system image name.
///
/// When initiated using `String`s, `SystemImageCollection`
/// conforms to `Decodable` and exposes the `init(at:)`
/// initializer, accepting a `URL` for loading external `.json` files.
/// Check out the ones provided within the module bundle for the structure.
public struct SystemImageCollection<Value: Hashable>: Hashable {
    /// Ordered section keys together with their icon.
    public let keys: [SystemImageSection]
    /// A dictionary containing a sorted array of _SF Symbol_ identifier for each section.
    public let values: [String: [Value]]
    /// A key path to extract the sysem image identifier from a given value.
    public let id: KeyPath<Value, String>

    /// Init.
    ///
    /// - parameters:
    ///     - keys: An array of `SystemImageSection`s.
    ///     - values: A dictionary containing a sorted array of _SF Symbol_ identifiers for each section.
    ///     - id: A `Value` key path pointing to the _SF Symbol_ identifier.
    init(
        keys: [SystemImageSection],
        withValues values: [String: [Value]],
        id: KeyPath<Value, String>
    ) {
        self.keys = keys
        self.values = values
        self.id = id
    }

    /// Filter an existence collection.
    ///
    /// Return an empty dictionary from within the filter to
    /// remove the category altogether.
    ///
    /// ```swift
    /// // Remove the "Maps" section and keep only filled symbols.
    /// let fillOnlyWithoutMaps: SystemImageCollection = .default.filter { key, values in
    ///     switch key.id {
    ///     case "Maps": return []
    ///     default: return values.filter { $0.localizedStandardContains(".fill") }
    ///     }
    /// }
    /// ```
    ///
    /// - parameter filter: The filter mechanism. Return an empty collection to discard the category.
    /// - returns: A new collection.
    public func filter(_ filter: (_ section: SystemImageSection, _ values: [Value]) -> [Value]) -> Self {
        var newKeys: [SystemImageSection] = []
        var newValues: [String: [Value]] = [:]
        keys.forEach {
            guard let values = values[$0.id], !values.isEmpty else { return }
            let filteredValues = filter($0, values)
            guard !filteredValues.isEmpty else { return }
            newKeys.append($0)
            newValues[$0.id] = filteredValues
        }
        return .init(keys: newKeys, withValues: newValues, id: id)
    }
}

/// A `struct` defining a picker section.
public struct SystemImageSection: Decodable, Hashable, Identifiable {
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

/// An `enum` listing all available `SystemImageCollection` coding keys.
private enum SystemImageCollectionCodingKeys: CodingKey {
    case keys
    case values
}

extension SystemImageCollection: Decodable where Value == String {
    /// The version-specific default collection.
    public static let `default`: Self = {
        let url: URL?
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
            url = Bundle.module.url(forResource: "symbols5", withExtension: "json")
        } else if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            url = Bundle.module.url(forResource: "symbols4", withExtension: "json")
        } else {
            #if DEBUG
            fatalError("Unsupported OS version.")
            #else
            url = nil
            #endif
        }
        // Try and load them.
        guard let url,
              let collection = try? SystemImageCollection(at: url) else {
            return .init(keys: [], withValues: [:], id: \.self)
        }
        return collection
    }()

    /// Load  a collection from a `.json` file at a given URL.
    ///
    /// - parameter url: The `URL` to the `.json` _SF Symbols_ file.
    public init(at url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try JSONDecoder().decode(Self.self, from: data)
    }

    /// Init with decoder.
    ///
    /// - parameter decoder: Some `Decoder`.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SystemImageCollectionCodingKeys.self)
        let keys = try container.decode([SystemImageSection].self, forKey: .keys)
        let values = try container.decode([String: [Value]].self, forKey: .values)
        self.init(keys: keys, withValues: values)
    }
}

public extension SystemImageCollection where Value: StringProtocol {
    /// Init.
    ///
    /// - parameters:
    ///     - keys: An array of `SystemImageSection`s.
    ///     - values: A dictionary containing a sorted array of _SF Symbol_ identifiers for each section.
    init(keys: [SystemImageSection], withValues values: [String: [Value]]) {
        self.init(keys: keys, withValues: values, id: \.localizedLowercase)
    }
}

public extension SystemImageCollection where Value: Identifiable, Value.ID: StringProtocol {
    /// Init.
    ///
    /// - parameters:
    ///     - keys: An array of `SystemImageSection`s.
    ///     - values: A dictionary containing a sorted array of _SF Symbol_ identifiers for each section.
    init(keys: [SystemImageSection], withValues values: [String: [Value]]) {
        self.init(keys: keys, withValues: values, id: \.id.localizedLowercase)
    }
}

public extension SystemImageCollection where Value: RawRepresentable, Value.RawValue == String {
    /// The version-specific default collection.
    static var `default`: Self {
        let collection: SystemImageCollection<String> = .default
        return .init(keys: collection.keys, withValues: collection.values.mapValues {
            $0.compactMap(Value.init(rawValue:))
        })
    }
}

public extension SystemImageCollection where Value: RawRepresentable, Value.RawValue: StringProtocol {
    /// Init.
    ///
    /// - parameters:
    ///     - keys: An array of `SystemImageSection`s.
    ///     - values: A dictionary containing a sorted array of _SF Symbol_ identifiers for each section.
    init(keys: [SystemImageSection], withValues values: [String: [Value]]) {
        self.init(keys: keys, withValues: values, id: \.rawValue.localizedLowercase)
    }
}