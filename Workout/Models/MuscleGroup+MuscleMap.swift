// SPDX-License-Identifier: AGPL-3.0-or-later
//
//  MuscleGroup+MuscleMap.swift
//  Workout
//
//  Bridges the app's MuscleGroup enum to MuscleMap's Muscle type
//  for heatmap rendering in the Recovery tab.
//

import MuscleMap

extension MuscleGroup {
    /// Returns the corresponding MuscleMap Muscle for heatmap rendering.
    var bodyMuscle: Muscle {
        switch self {
        case .chest:      return .chest
        case .shoulders:  return .deltoids
        case .biceps:     return .biceps
        case .triceps:    return .triceps
        case .forearms:   return .forearm
        case .lats:       return .upperBack
        case .traps:      return .trapezius
        case .lowerBack:  return .lowerBack
        case .neck:       return .neck
        case .abs:        return .abs
        case .glutes:     return .gluteal
        case .hamstrings: return .hamstring
        case .quadriceps: return .quadriceps
        case .calves:     return .calves
        }
    }
}

extension Muscle {
    /// Maps a MuscleMap Muscle back to this app's MuscleGroup.
    /// Returns nil for body parts the app doesn't track (head, feet, hands, etc.).
    var muscleGroup: MuscleGroup? {
        switch self {
        case .chest, .upperChest, .lowerChest:
            return .chest
        case .deltoids, .frontDeltoid, .rearDeltoid:
            return .shoulders
        case .biceps:
            return .biceps
        case .triceps:
            return .triceps
        case .forearm:
            return .forearms
        case .upperBack, .rhomboids, .rotatorCuff:
            return .lats
        case .trapezius, .upperTrapezius, .lowerTrapezius:
            return .traps
        case .lowerBack:
            return .lowerBack
        case .neck:
            return .neck
        case .abs, .upperAbs, .lowerAbs, .obliques, .serratus:
            return .abs
        case .gluteal, .adductors, .hipFlexors:
            return .glutes
        case .hamstring:
            return .hamstrings
        case .quadriceps, .innerQuad, .outerQuad:
            return .quadriceps
        case .calves, .tibialis:
            return .calves
        default:
            // feet, hands, head, knees, ankles — not tracked
            return nil
        }
    }
}
