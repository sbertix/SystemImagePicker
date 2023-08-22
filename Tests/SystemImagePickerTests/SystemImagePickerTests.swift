//
//  SystemImagePickerTests.swift
//  SystemImagePickerTests
//
//  Created by Stefano Bertagno on 20/08/23.
//

import XCTest

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@testable import SystemImagePicker

final class SystemImagePickerTests: XCTestCase {
    /// Test there are no missing _SF Symbols_.
    func testMissingSystemImages() throws {
        var systemImageNames = try loadSystemImages()
        // Remove existing ones.
        let collection: SystemImageCollection = .default
        collection.values.forEach { $0.value.forEach { systemImageNames.remove($0) }}
        XCTAssertEqual(systemImageNames.sorted(), [])
    }

    /// Test all provided sections are non-empty.
    func testNonEmptySections() {
        SystemImageCollection.default.values.values.forEach {
            XCTAssertFalse($0.isEmpty)
        }
    }

    /// Test all provided sections have valid _SF Symbols_.
    func testSystemImageHeader() {
        SystemImageCollection.default
            .keys
            .map(\.systemImage)
            .forEach {
                XCTAssertNotNil($0)
                guard let name = $0 else { return }
                assertValidSystemImage(name)
            }
    }

    /// Test the availability of all provided _SF Symbol_ identifiers.
    func testSystemImageNames() {
        SystemImageCollection.default.values.values.forEach {
            $0.forEach(assertValidSystemImage)
        }
    }

    // MARK: Private

    /// Test a _SF Symbol_ actually exists for a given name.
    ///
    /// - parameter name: The tentative _SF Symbol_ identifier..
    private func assertValidSystemImage(_ name: String) {
        #if canImport(AppKit)
        XCTAssertNotNil(
            NSImage(systemSymbolName: name, accessibilityDescription: nil),
            "\"\(name)\" was found to be `nil`."
        )
        #elseif canImport(UIKit)
        XCTAssertNotNil(
            UIImage(systemName: name),
            "\"\(name)\" was found to be `nil`."
        )
        #endif
    }

    /// Load the correct plain list of _SF Symbols_.
    ///
    /// - returns: A set of _SF Symbol_ identifiers.
    /// - throws: Any `Error`.
    private func loadSystemImages() throws -> Set<String> {
        let url: URL?
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
            url = Bundle.module.url(forResource: "symbols5", withExtension: "txt")
        } else if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            url = Bundle.module.url(forResource: "symbols4", withExtension: "txt")
        } else {
            url = Bundle.module.url(forResource: "symbols3", withExtension: "txt")
        }
        guard let url else {
            XCTFail("Invalid URL for symbols file.")
            return []
        }
        return try .init(String(contentsOf: url).split(separator: "\n").map(String.init))
    }
}
