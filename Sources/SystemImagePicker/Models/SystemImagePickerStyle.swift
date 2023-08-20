//
//  SystemImagePickerStyle.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 20/08/23.
//

import Foundation
import SwiftUI

/// An `enum` listing all supported `SystemImagePicker` styles.
public enum SystemImagePickerStyle {
    /// A vertical compact grid layout.
    case grid

    #if os(iOS) || os(watchOS)
    /// A simple list of all symbols together with their name.
    case list
    #endif
}

public extension SystemImagePickerStyle {
    /// The default image picker style.
    static let `default`: Self = .grid
}
