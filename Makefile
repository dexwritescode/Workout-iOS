PROJECT := Workout.xcodeproj
SCHEME  := Workout
SIM     := iPhone 17 Pro
BUNDLE  := com.example.Workout

.DEFAULT_GOAL := help

# ── Build & Test ──────────────────────────────────────────────────────────────

.PHONY: build
build: ## Build for simulator (no signing required)
	xcodebuild \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Debug \
		-sdk iphonesimulator \
		CODE_SIGNING_ALLOWED=NO \
		build

.PHONY: test
test: ## Run unit tests on $(SIM)
	xcodebuild clean test \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-destination "platform=iOS Simulator,name=$(SIM)" \
		CODE_SIGNING_ALLOWED=NO

# ── Run ───────────────────────────────────────────────────────────────────────

.PHONY: run
run: ## Build and launch in the simulator
	@SIM_ID=$$(xcrun simctl list devices available | grep "$(SIM)" | head -1 | sed 's/.*(\([A-F0-9-]*\)).*/\1/') && \
	xcodebuild \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-configuration Debug \
		-destination "platform=iOS Simulator,id=$$SIM_ID" \
		CODE_SIGNING_ALLOWED=NO \
		build && \
	xcrun simctl boot $$SIM_ID 2>/dev/null || true && \
	open -a Simulator && \
	APP_PATH=$$(find ~/Library/Developer/Xcode/DerivedData -name "$(SCHEME).app" -path "*iphonesimulator*" 2>/dev/null | head -1) && \
	xcrun simctl install $$SIM_ID "$$APP_PATH" && \
	xcrun simctl launch $$SIM_ID $(BUNDLE)

# ── Help ──────────────────────────────────────────────────────────────────────

.PHONY: help
help: ## Show available targets
	@echo "Usage: make [target]"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  \033[1;32m%-18s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
