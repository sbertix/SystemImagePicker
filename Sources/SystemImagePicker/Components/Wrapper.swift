//
//  Wrapper.swift
//  SystemImagePicker
//
//  Created by Stefano Bertagno on 21/08/23.
//

import Foundation
import SwiftUI

/// A `struct` defining the outside container for the picker.
struct Wrapper<Content: View>: View {
    /// The view builder.
    let content: () -> Content

    /// The underlying view.
    var body: some View {
        #if !os(macOS)
        if #available(iOS 16, watchOS 9, *) {
            NavigationStack {
                content().navigationBarTitleDisplayMode(.inline)
            }
        } else {
            NavigationView {
                content().navigationBarTitleDisplayMode(.inline)
            }.navigationViewStyle(.stack)
        }
        #else
        content().frame(
            minWidth: 432,
            idealWidth: 540,
            minHeight: 340,
            idealHeight: 340
        )
        #endif
    }
}
