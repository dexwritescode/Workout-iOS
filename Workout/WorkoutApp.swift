// SPDX-License-Identifier: AGPL-3.0-or-later
//
//  WorkoutApp.swift
//  Workout
//
//  Created by Dexter Darwich on 2025-12-30.
//

import SwiftUI
import SwiftData

@main
struct WorkoutApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: SchemaV1.self)
        let inMemory = CommandLine.arguments.contains("--ui-testing")
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)

        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: WorkoutMigrationPlan.self,
                configurations: [modelConfiguration]
            )
        } catch {
            // Persistent store unavailable (e.g. simulator sandbox in CI) — fall back to in-memory.
            let fallback = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            return try! ModelContainer(
                for: schema,
                migrationPlan: WorkoutMigrationPlan.self,
                configurations: [fallback]
            )
        }
    }()

    @State private var themeManager = ThemeManager.shared
    @State private var activeWorkoutCoordinator = ActiveWorkoutCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(themeManager)
                .environment(activeWorkoutCoordinator)
                .preferredColorScheme(.dark)
                .onAppear {
                    let context = sharedModelContainer.mainContext
                    SeedDataService.seedIfNeeded(modelContext: context)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
