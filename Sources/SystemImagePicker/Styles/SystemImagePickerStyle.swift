//
//  SystemImagePickerStyle.swift
//
//
//  Created by Stefano Bertagno on 22/08/23.
//

import Foundation
import SwiftUI

/// A `protocol` defining the overall appearance of
/// the system image picker.
///
/// All methods provide default implementations, equivalent
/// to `DefaultSystemImagePickerStyle`, so you can
/// even update a single component without having to
/// implement all others.
public protocol SystemImagePickerStyle {
    /// The associated header cell.
    associatedtype HeaderCell: View
    /// The associated cell.
    associatedtype Cell: View

    /// The ideal with for the _SF Symbol_ cell.
    ///
    /// The adaptive layout will fit them between 10% of this value.
    var cellIdealWidth: CGFloat { get }

    /// The height of the _SF Symbol_ cell.
    ///
    /// When passing `nil`, the dyamic cell width is automatically
    /// tracked and used to apply a 1:1 aspect ratio.
    var cellHeight: CGFloat? { get }

    /// Compose the header cell.
    ///
    /// - parameters:
    ///     - title: The section name.
    ///     - systemImage: The related _SF Symbol_ identifier, if it exists.
    ///     - isSelected: Whether it's the current selection or not.
    ///     - count: The amount of items inside the section.
    /// - returns: Some `HeaderCell`.
    @ViewBuilder func headerCell(
        with title: String,
        systemImage: String?,
        isSelected: Bool,
        count: Int
    ) -> HeaderCell

    /// Compose the _SF Symbol_ cell.
    ///
    /// - parameters:
    ///     - systemImage: The related _SF Symbol_ identifier.
    ///     - isSelected: Whether it's the current selection or not.
    /// - returns: Some `Cell`.
    @ViewBuilder func cell(with systemImage: String, isSelected: Bool) -> Cell
}
