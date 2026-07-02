// SPDX-License-Identifier: AGPL-3.0-or-later
//
//  MuscleSilhouetteView.swift
//  Workout
//
//  Interactive anterior/posterior body silhouette with fatigue heatmap.
//  Swipe left/right to toggle between front and back views.
//  Tapping a muscle region sets selectedMuscle to highlight the list row below.
//

import SwiftUI
import SwiftData
import MuscleMap

struct MuscleSilhouetteView: View {
    let recoveryStates: [MuscleRecoveryState]
    @Binding var selectedMuscle: MuscleGroup?

    @State private var side: BodySide = .front
    @State private var dragOffset: CGFloat = 0

    // MARK: - Derived data

    /// Live fatigue values as MuscleIntensity entries.
    /// intensity 0.0 = fully recovered, 1.0 = fully fatigued.
    private var intensities: [MuscleIntensity] {
        recoveryStates.compactMap { (state) -> MuscleIntensity? in
            guard let muscle = state.muscle else { return nil }
            return MuscleIntensity(
                muscle: muscle.bodyMuscle,
                intensity: state.currentFatigue
            )
        }
    }

    /// Custom style: surface3 body fill so the silhouette reads against
    /// the dark surface1 card background; slightly brighter stroke lines.
    private var bodyStyle: BodyViewStyle {
        BodyViewStyle(
            defaultFillColor: Color(hex: 0x252528),   // AppStyle.Colors.surface3
            strokeColor: .white.opacity(0.18),
            strokeWidth: 1.5,
            selectionColor: AppStyle.Colors.brand.opacity(0.15),
            selectionStrokeColor: AppStyle.Colors.brand,
            selectionStrokeWidth: 2,
            headColor: Color(hex: 0x252528),
            hairColor: Color(hex: 0x1C1C1F),
            shadowColor: .clear,
            shadowRadius: 0,
            shadowOffset: .zero
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                BodyView(gender: .male, side: side)
                    .heatmap(intensities, colorScale: .workout)
                    .bodyStyle(bodyStyle)
                    .onMuscleSelected { muscle, _ in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedMuscle = muscle.muscleGroup
                        }
                    }
                    .frame(height: 300)
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                if abs(value.translation.width) > 50 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        side = (side == .front) ? .back : .front
                                    }
                                }
                                dragOffset = 0
                            }
                    )

                // Swipe hint icon
                Image(systemName: "rotate.3d")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(AppStyle.Colors.textTertiary)
                    .padding(10)
            }

            // Side label + legend
            HStack(alignment: .center) {
                HStack(spacing: 5) {
                    Circle()
                        .fill(AppStyle.Colors.success)
                        .frame(width: 7, height: 7)
                    Text("Recovered")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(AppStyle.Colors.textTertiary)
                }

                Spacer()

                Text(side == .front ? "Front" : "Back")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AppStyle.Colors.textTertiary)
                    .animation(.easeInOut(duration: 0.2), value: side)

                Spacer()

                HStack(spacing: 5) {
                    Text("Fatigued")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(AppStyle.Colors.textTertiary)
                    Circle()
                        .fill(AppStyle.Colors.error)
                        .frame(width: 7, height: 7)
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

#Preview {
    NavigationStack {
        MuscleSilhouetteView(
            recoveryStates: [],
            selectedMuscle: .constant(nil)
        )
        .padding()
        .background(AppStyle.Colors.surface1)
    }
    .modelContainer(for: MuscleRecoveryState.self, inMemory: true)
}
