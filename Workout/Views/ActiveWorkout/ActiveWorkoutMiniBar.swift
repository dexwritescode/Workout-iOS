// SPDX-License-Identifier: AGPL-3.0-or-later
//
//  ActiveWorkoutMiniBar.swift
//  Workout
//
//  Bottom accessory shown above the tab bar while a workout is active and
//  minimized. Tap to expand back into the full-screen ActiveWorkoutView.
//

import SwiftUI

struct ActiveWorkoutMiniBar: View {
    @Environment(ActiveWorkoutCoordinator.self) private var coordinator
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement

    var body: some View {
        Button {
            coordinator.expand()
        } label: {
            content
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var content: some View {
        if let viewModel = coordinator.viewModel, let session = viewModel.session {
            switch placement {
            case .expanded:
                expandedContent(viewModel: viewModel, startTime: session.startTime)
            default:
                inlineContent(viewModel: viewModel, startTime: session.startTime)
            }
        }
    }

    private func inlineContent(viewModel: ActiveWorkoutViewModel, startTime: Date) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppStyle.Colors.brand)

            Text(viewModel.sessionName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppStyle.Colors.text)
                .lineLimit(1)

            Spacer()

            TimelineView(.periodic(from: .now, by: 1)) { context in
                Text(ActiveWorkoutViewModel.formatDuration(context.date.timeIntervalSince(startTime)))
                    .font(AppStyle.Typography.mono(13, weight: .medium))
                    .foregroundStyle(AppStyle.Colors.brand)
                    .contentTransition(.numericText())
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 14)
        .contentShape(Rectangle())
    }

    private func expandedContent(viewModel: ActiveWorkoutViewModel, startTime: Date) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppStyle.Colors.brand)
                .frame(width: 36, height: 36)
                .background(AppStyle.Colors.brand.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text(viewModel.sessionName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppStyle.Colors.text)
                    .lineLimit(1)

                currentExerciseLabel(viewModel: viewModel)
                    .font(.system(size: 12))
                    .foregroundStyle(AppStyle.Colors.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            TimelineView(.periodic(from: .now, by: 1)) { context in
                Text(ActiveWorkoutViewModel.formatDuration(context.date.timeIntervalSince(startTime)))
                    .font(AppStyle.Typography.mono(15, weight: .semibold))
                    .foregroundStyle(AppStyle.Colors.brand)
                    .contentTransition(.numericText())
                    .monospacedDigit()
            }

            Image(systemName: "chevron.up")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppStyle.Colors.textTertiary)
        }
        .padding(.horizontal, 14)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private func currentExerciseLabel(viewModel: ActiveWorkoutViewModel) -> some View {
        let exercises = viewModel.allTemplateExercises
        if !exercises.isEmpty, viewModel.currentExerciseIndex < exercises.count,
           let name = exercises[viewModel.currentExerciseIndex].exercise?.name {
            Text(name)
        } else {
            Text("In progress")
        }
    }
}
