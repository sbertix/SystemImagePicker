//
//  AnySystemImagePickerStyle.swift
//
//
//  Created by Stefano Bertagno on 22/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining a type-erased system image picker style.
///
/// `DefaultSystemPickerStyle` is never stored, to avoid
/// the `AnyView` typecasting when possible.
public struct AnySystemImagePickerStyle {
    private let _cellIdealWidth: (() -> CGFloat)?
    private let _cellHeight: (() -> CGFloat?)?

    private let _headerCell: ((
        _ title: String,
        _ systemImage: String?,
        _ isSelected: Bool,
        _ count: Int
    ) -> AnyView)?

    private let _cell: ((
        _ systemImage: String,
        _ isSelected: Bool
    ) -> AnyView)?

    /// Init.
    ///
    /// - parameter style: Some `SystemImagePickerStyle`.
    init(_ style: some SystemImagePickerStyle) {
        if style is DefaultSystemImagePickerStyle {
            // Everything should be `nil`.
            self._cellIdealWidth = nil
            self._cellHeight = nil
            self._headerCell = nil
            self._cell = nil
        } else if let style = style as? AnySystemImagePickerStyle {
            // Avoid chaining multiple generators.
            self = style
        } else {
            self._cellIdealWidth = { style.cellIdealWidth }
            self._cellHeight = { style.cellHeight }
            self._headerCell = {
                .init(style.headerCell(
                    with: $0,
                    systemImage: $1,
                    isSelected: $2,
                    count: $3
                ))
            }
            self._cell = { .init(style.cell(with: $0, isSelected: $1)) }
        }
    }
}

extension AnySystemImagePickerStyle: SystemImagePickerStyle {
    /// The ideal with for the _SF Symbol_ cell.
    ///
    /// The adaptive layout will fit them between 10% of this value.
    public var cellIdealWidth: CGFloat {
        _cellIdealWidth?() ?? DefaultSystemImagePickerStyle().cellIdealWidth
    }

    /// The height of the _SF Symbol_ cell.
    ///
    /// When passing `nil`, the dyamic cell width is automatically
    /// tracked and used to apply a 1:1 aspect ratio.
    public var cellHeight: CGFloat? {
        _cellHeight?() ?? DefaultSystemImagePickerStyle().cellHeight
    }

    /// Compose the header cell.
    ///
    /// - parameters:
    ///     - title: The section name.
    ///     - systemImage: The related _SF Symbol_ identifier, if it exists.
    ///     - isSelected: Whether it's the current selection or not.
    ///     - count: The amount of items inside the section.
    /// - returns: Some `HeaderCell`.
    @ViewBuilder public func headerCell(
        with title: String,
        systemImage: String?,
        isSelected: Bool,
        count: Int
    ) -> some View {
        if let _headerCell {
            _headerCell(title, systemImage, isSelected, count)
        } else {
            DefaultSystemImagePickerStyle().headerCell(
                with: title,
                systemImage: systemImage,
                isSelected: isSelected,
                count: count
            )
        }
    }

    /// Compose the _SF Symbol_ cell.
    ///
    /// - parameters:
    ///     - systemImage: The related _SF Symbol_ identifier.
    ///     - isSelected: Whether it's the current selection or not.
    /// - returns: Some `Cell`.
    @ViewBuilder public func cell(with systemImage: String, isSelected: Bool) -> some View {
        if let _cell {
            _cell(systemImage, isSelected)
        } else {
            DefaultSystemImagePickerStyle().cell(with: systemImage, isSelected: isSelected)
        }
    }
}
