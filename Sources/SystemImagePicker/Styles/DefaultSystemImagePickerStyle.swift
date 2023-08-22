//
//  DefaultSystemImagePickerStyle.swift
//
//
//  Created by Stefano Bertagno on 22/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining the default layout of a system image picker.
public struct DefaultSystemImagePickerStyle: SystemImagePickerStyle {}

public extension SystemImagePickerStyle where Self == DefaultSystemImagePickerStyle {
    /// The default layout for a system image picker.
    static var `default`: Self { DefaultSystemImagePickerStyle() }
}

public extension SystemImagePickerStyle {
    /// The ideal with for the _SF Symbol_ cell.
    ///
    /// The adaptive layout will fit them between 10% of this value.
    var cellIdealWidth: CGFloat {
        #if os(iOS)
        64
        #elseif os(macOS)
        48
        #elseif os(tvOS)
        128
        #elseif compiler(>=5.9) && os(visionOS)
        64
        #else
        48
        #endif
    }

    /// The height of the _SF Symbol_ cell.
    ///
    /// When passing `nil`, the dyamic cell width is automatically
    /// tracked and used to apply a 1:1 aspect ratio.
    var cellHeight: CGFloat? { nil }
}

public extension SystemImagePickerStyle where HeaderCell == HeaderCellContent {
    /// Compose the header cell.
    ///
    /// - parameters:
    ///     - title: The section name.
    ///     - systemImage: The related _SF Symbol_ identifier, if it exists.
    ///     - isSelected: Whether it's the current selection or not.
    ///     - count: The amount of items inside the section.
    /// - returns: Some `View`.
    func headerCell(
        with title: String,
        systemImage: String?,
        isSelected: Bool,
        count: Int
    ) -> HeaderCellContent {
        HeaderCellContent(
            title: title,
            systemImage: systemImage,
            isSelected: isSelected,
            count: count
        )
    }
}

public extension SystemImagePickerStyle where Cell == CellContent {
    /// Compose the _SF Symbol_ cell.
    ///
    /// - parameters:
    ///     - systemImage: The related _SF Symbol_ identifier.
    ///     - isSelected: Whether it's the current selection or not.
    /// - returns: Some `Cell`.
    func cell(with systemImage: String, isSelected: Bool) -> CellContent {
        CellContent(systemImage: systemImage, isSelected: isSelected)
    }
}
