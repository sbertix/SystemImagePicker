//
//  SystemImageCollection.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation

/// An `enum` listing all available `SystemImageCollection` coding keys.
private enum SystemImageCollectionCodingKeys: CodingKey {
    case keys
    case values
}

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
        // - `values` and `keys` SHOULD generally have the same amount of items.
        // - `keys` CAN be empty when `values` has exactly one item, for an ungroupped layout.
        if values.count != keys.count && (!keys.isEmpty || values.count > 1) {
            #if DEBUG
            fatalError("Invalid number of items for `keys` (\(keys.count)) and `values` (\(values.count)).")
            #endif
        }
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
        // Consider the unsectioned scenario separately.
        if keys.isEmpty,
           values.count == 1,
           let unsectionedValues = values[""],
           !unsectionedValues.isEmpty {
            let filteredValues = filter(.init(title: "", systemImage: nil), unsectionedValues)
            if !filteredValues.isEmpty { newValues[""] = filteredValues }
        } else {
            keys.forEach {
                guard let values = values[$0.id], !values.isEmpty else { return }
                let filteredValues = filter($0, values)
                guard !filteredValues.isEmpty else { return }
                newKeys.append($0)
                newValues[$0.id] = filteredValues
            }
        }
        return .init(keys: newKeys, withValues: newValues, id: id)
    }
}

extension SystemImageCollection: Codable where Value == String {
    /// The version-specific default collection.
    public static let `default`: Self = {
        let url: URL?
        if #available(iOS 17, macOS 14, watchOS 10, *) {
            url = Bundle.module.url(forResource: "symbols5", withExtension: "json")
        } else if #available(iOS 16, macOS 13, watchOS 9, *) {
            url = Bundle.module.url(forResource: "symbols4", withExtension: "json")
        } else {
            url = Bundle.module.url(forResource: "symbols3", withExtension: "json")
        }
        // Try and load them.
        guard let url,
              let collection = try? SystemImageCollection(at: url) else {
            return .init(keys: [], withValues: [:], id: \.self)
        }
        return collection
    }()

    /// The version-specific **UNSECTIONED** default collection.
    public static let `unsectionedDefault`: Self = {
        let url: URL?
        if #available(iOS 17, macOS 14, watchOS 10, *) {
            url = Bundle.module.url(forResource: "symbols5", withExtension: "txt")
        } else if #available(iOS 16, macOS 13, watchOS 9, *) {
            url = Bundle.module.url(forResource: "symbols4", withExtension: "txt")
        } else {
            url = Bundle.module.url(forResource: "symbols3", withExtension: "txt")
        }
        // Try and load them.
        guard let url,
              let collection = try? SystemImageCollection(unsectionedAt: url) else {
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

    /// Load  a collection from a `.txt` file at a given URL.
    ///
    /// - parameter url: The `URL` to the `.txt` _SF Symbols_ file.
    public init(unsectionedAt url: URL) throws {
        let text = try String(contentsOf: url)
        self = .init(unsectionedValues: text.split(separator: "\n").map(String.init))
    }

    /// Init with decoder.
    ///
    /// - parameter decoder: Some `Decoder`.
    /// - throws: Any `Error`.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SystemImageCollectionCodingKeys.self)
        let keys = try container.decode([SystemImageSection].self, forKey: .keys)
        let values = try container.decode([String: [Value]].self, forKey: .values)
        self.init(keys: keys, withValues: values)
    }

    /// Encode using some encoder.
    ///
    /// - parameter encoder: Some `Encoder`.
    /// - throws: Any `Error`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SystemImageCollectionCodingKeys.self)
        try container.encode(keys, forKey: .keys)
        try container.encode(values, forKey: .values)
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

    /// Init.
    ///
    /// - parameters:
    ///     - values: A sorted array of _SF Symbol_ identifiers for each section.
    init(unsectionedValues values: [Value]) {
        self.init(keys: [], withValues: ["": values])
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

    /// Init.
    ///
    /// - parameters:
    ///     - values: A sorted array of _SF Symbol_ identifiers for each section.
    init(unsectionedValues values: [Value]) {
        self.init(keys: [], withValues: ["": values])
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

    /// The version-specific default **UNSECTIONED** collection.
    static var `unsectionedDefault`: Self {
        let collection: SystemImageCollection<String> = .unsectionedDefault
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

    /// Init.
    ///
    /// - parameters:
    ///     - values: A sorted array of _SF Symbol_ identifiers for each section.
    init(unsectionedValues values: [Value]) {
        self.init(keys: [], withValues: ["": values])
    }
}
