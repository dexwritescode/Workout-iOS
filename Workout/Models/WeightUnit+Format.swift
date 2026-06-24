// SPDX-License-Identifier: AGPL-3.0-or-later
//
//  WeightUnit+Format.swift
//  Workout
//

import Foundation

extension WeightUnit {
    /// Formats a weight value with smart decimal handling:
    /// whole numbers show no decimal ("225 lbs"), fractional values show one place ("102.5 kg").
    func formatted(_ value: Double) -> String {
        let display = value.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", value)
            : String(format: "%.1f", value)
        return "\(display) \(abbreviation)"
    }

    /// Converts a weight stored in `storedUnit` and formats it for display in this unit.
    func display(_ value: Double, storedIn storedUnit: WeightUnit) -> String {
        formatted(storedUnit.convert(value, to: self))
    }
}
