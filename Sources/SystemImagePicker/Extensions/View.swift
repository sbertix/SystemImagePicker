//
//  View.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 22/08/23.
//

import Foundation
import SwiftUI

public extension View {
    // MARK: Sectioned

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    ///     - data: A collection of _SF Symbol_ representations to pick from.
    /// - returns: Some `View`.
    func systemImagePicker<T: Hashable>(
        isPresented: Binding<Bool>,
        selection: Binding<T>,
        data: SystemImageCollection<T>
    ) -> some View {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection, data: data)
        }
    }

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    /// - returns: Some `View`.
    func systemImagePicker(
        isPresented: Binding<Bool>,
        selection: Binding<String>
    ) -> some View {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection)
        }
    }

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    /// - returns: Some `View`.
    func systemImagePicker<T: Hashable & RawRepresentable>(
        isPresented: Binding<Bool>,
        selection: Binding<T>
    ) -> some View where T.RawValue == String {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection, data: .default)
        }
    }

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    ///     - data: A collection of _SF Symbol_ representations to pick from.
    /// - returns: Some `View`.
    func systemImagePicker<T: Hashable>(
        isPresented: Binding<Bool>,
        selection: Binding<T?>,
        data: SystemImageCollection<T>
    ) -> some View {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection, data: data)
        }
    }

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    /// - returns: Some `View`.
    func systemImagePicker(
        isPresented: Binding<Bool>,
        selection: Binding<String?>
    ) -> some View {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection)
        }
    }

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    /// - returns: Some `View`.
    func systemImagePicker<T: Hashable & RawRepresentable>(
        isPresented: Binding<Bool>,
        selection: Binding<T?>
    ) -> some View where T.RawValue == String {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection, data: .default)
        }
    }

    // MARK: Unsectioned

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    ///     - data:An array of sorted _SF Symbol_ identifiers to pick from.
    /// - returns: Some `View`.
    func systemImagePicker<T: Hashable & StringProtocol>(
        isPresented: Binding<Bool>,
        selection: Binding<T>,
        data: [T]
    ) -> some View {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection, data: data)
        }
    }

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    ///     - data:An array of sorted _SF Symbol_ identifiers to pick from.
    /// - returns: Some `View`.
    func systemImagePicker<T: Hashable & Identifiable>(
        isPresented: Binding<Bool>,
        selection: Binding<T>,
        data: [T]
    ) -> some View where T.ID: StringProtocol {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection, data: data)
        }
    }

    /// Toggle the visbility of a system image picker
    /// initiated with selection and data.
    ///
    /// - parameters:
    ///     - isPresented: Whether it's should be displayed or not.
    ///     - selection: The selected _SF Symbol_ representation binding.
    ///     - data:An array of sorted _SF Symbol_ identifiers to pick from.
    /// - returns: Some `View`.
    func systemImagePicker<T: Hashable & RawRepresentable>(
        isPresented: Binding<Bool>,
        selection: Binding<T>,
        data: [T]
    ) -> some View where T.RawValue: StringProtocol {
        sheet(isPresented: isPresented) {
            SystemImagePicker(selection: selection, data: data)
        }
    }
}
