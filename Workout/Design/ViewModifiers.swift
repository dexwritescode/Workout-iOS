// SPDX-License-Identifier: AGPL-3.0-or-later
//
//  ViewModifiers.swift
//  Workout
//
//  Reusable ViewModifiers and View extensions for common UI patterns.
//

import SwiftUI

// MARK: - Section Header

struct SectionHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(AppStyle.Colors.textSecondary)
            .textCase(.uppercase)
            .tracking(0.7)
    }
}

// MARK: - View Extensions

extension View {
    /// Uppercase section header style
    func sectionHeader() -> some View {
        modifier(SectionHeaderModifier())
    }
}
