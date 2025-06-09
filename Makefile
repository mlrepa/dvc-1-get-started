.PHONY: help install test lint format clean run-pipeline tutorial-setup tutorial-clean tutorial-init tutorial-file tutorial-directory tutorial-changes tutorial-versions tutorial-remotes tutorial-advanced tutorial-pipelines tutorial-full tutorial-reset
CODE_DIRS = src/ tests/

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup-hooks: ## Install pre-commit hooks
	uv run pre-commit install
	@echo "Pre-commit hooks installed!

install: ## Install dependencies
	uv sync --group dev
	uv run pre-commit install

pre-commit: ## Run pre-commit on all files
	uv run pre-commit run --all-files


format: ## Format code using Ruff formatter
	@echo "Formatting code..."
	uv run ruff format $(CODE_DIRS)

format-check: ## Check if code is formatted correctly (for CI)
	@echo "Checking code formatting..."
	uv run ruff format --check $(CODE_DIRS)

lint: ## Check for linting issues using Ruff (no fixes)
	@echo "Linting code..."
	uv run ruff check $(CODE_DIRS)

lint-fix: ## Attempt to automatically fix linting issues using Ruff
	@echo "Attempting to fix linting issues..."
	uv run ruff check --fix $(CODE_DIRS)

autofix: lint-fix format ## Automatically fix linting issues and then format code
	@echo "Code auto-fixing and formatting complete."

type-check: ## Run mypy type checking separately
	uv run mypy src/ --config-file=pyproject.toml

check-all: lint format-check type-check test pre-commit ## Run all checks (lint + test)
	@echo "All checks complete."


# =============================================================================
# DVC TUTORIAL TARGETS
# =============================================================================

tutorial-clean: ## Clean up all DVC-related files and data (reset to initial state)
	@echo "🧹 Cleaning up DVC tutorial state..."
	@# Remove DVC directory and config
	rm -rf .dvc/
	@# Remove all .dvc files
	find . -name "*.dvc" -type f -delete
	@# Remove data directories and files created during tutorial
	rm -rf data/
	rm -rf datadir/
	rm -rf cats-dogs-untracked/
	rm -rf imported_data.xml* external_data.xml*
	@# Remove pipeline files
	rm -rf dvc.yaml dvc.lock
	rm -rf model.weights.h5 metrics.csv
	@# Remove temporary remote storage
	rm -rf /tmp/dvc_remote_storage
	@# Clean git index of any staged DVC files
	-git reset HEAD *.dvc .dvc/ dvc.yaml 2>/dev/null || true
	@# Remove any DVC-related entries from .gitignore that might have been added
	@if [ -f .gitignore ]; then \
		grep -v "^/data" .gitignore > .gitignore.tmp && mv .gitignore.tmp .gitignore || true; \
		grep -v "^/datadir" .gitignore > .gitignore.tmp && mv .gitignore.tmp .gitignore || true; \
	fi
	@echo "✅ DVC tutorial cleanup complete! Repository reset to initial state."

tutorial-init: ## Initialize DVC in the project (Step 1.4)
	@echo "🚀 Step 1.4: Initialize DVC in Your Project"
	dvc init
	@echo "📁 DVC initialized! Let's see what was created:"
	ls -la .dvc/
	@echo "📝 Adding DVC files to Git..."
	git add .dvc/
	git commit -m "Initialize DVC"
	@echo "✅ DVC initialization complete!"

tutorial-file: tutorial-init ## Version your first dataset file (Section 2)
	@echo "⭐ Section 2: Versioning Your First Dataset (File)"
	@echo "📥 Step 2.1: Download Raw Data"
	mkdir -p data
	dvc get https://github.com/iterative/dataset-registry get-started/data.xml -o data/data.xml
	@echo "📝 Step 2.2: Add the File to DVC"
	dvc add data/data.xml -v
	@echo "👀 Let's inspect the .dvc file:"
	cat data/data.xml.dvc
	@echo "📝 Step 2.3: Commit DVC-file to Git"
	git add data/.gitignore data/data.xml.dvc
	git commit -m "Add raw data.xml"
	@echo "✅ File versioning complete!"

tutorial-directory: tutorial-file ## Version a directory dataset (Section 3)
	@echo "📁 Section 3: Versioning a Directory (Cats & Dogs Dataset)"
	@echo "🌿 Step 3.1: Create a New Git Branch"
	git checkout -b cats-dogs-v1
	@echo "📥 Step 3.2: Download the Cats & Dogs Dataset"
	dvc get --rev cats-dogs-v1 https://github.com/iterative/dataset-registry use-cases/cats-dogs -o datadir
	@echo "📝 Step 3.3: Add the Directory to DVC"
	dvc add datadir
	@echo "👀 Let's inspect the directory .dvc file:"
	cat datadir.dvc
	@echo "📝 Step 3.4: Commit the DVC-file and Tag the Version"
	git add .gitignore datadir.dvc
	git commit -m "Add cats-dogs dataset (v1)"
	git tag -a cats-dogs-v1 -m "Dataset version v1.0"
	@echo "✅ Directory versioning complete!"

tutorial-changes: tutorial-directory ## Track changes and update data (Section 4)
	@echo "♻️ Section 4: Tracking Changes & Updating Data"
	@echo "🔍 Step 4.1: Check Current DVC Status"
	dvc status
	@echo "🌿 Step 4.2: Introduce a New Data Version"
	git checkout -b cats-dogs-v2
	dvc get --rev cats-dogs-v2 https://github.com/iterative/dataset-registry use-cases/cats-dogs -o datadir
	@echo "🔍 Check status after data change:"
	dvc status
	@echo "📝 Step 4.3: Capture the New Data Version with DVC"
	dvc add datadir
	git add datadir.dvc
	git commit -m "Updated cats-dogs dataset (v2)"
	git tag -a cats-dogs-v2 -m "Dataset version v2.0"
	@echo "✅ Change tracking complete!"

tutorial-versions: tutorial-changes ## Switch between data versions (Section 5)
	@echo "⏪ Section 5: Switching Between Data Versions"
	@echo "🔄 Step 5.1: Switch to Different Branch"
	git checkout tutorial || git checkout main || git checkout master
	@echo "📁 Current files:"
	ls
	@echo "🔄 DVC checkout to sync data:"
	dvc checkout
	@echo "🔄 Step 5.2: Restore Specific Data Version"
	git checkout cats-dogs-v1
	@echo "📁 Files after git checkout:"
	ls
	@echo "🔄 DVC checkout to get v1 data:"
	dvc checkout
	@echo "✅ Version switching complete!"

tutorial-remotes: tutorial-versions ## Set up and use remotes (Section 6)
	@echo "☁️ Section 6: Storing and Sharing Data with Remotes"
	@echo "📁 Step 6.1: Set Up a Local Remote Storage"
	mkdir -p /tmp/dvc_remote_storage
	dvc remote add -d local_storage /tmp/dvc_remote_storage
	@echo "👀 Let's check the config:"
	cat .dvc/config
	git add .dvc/config
	git commit -m "Add local DVC remote storage"
	@echo "📤 Step 6.2: Push Data to Remote Storage"
	dvc push -v
	@echo "👀 Check remote storage:"
	ls /tmp/dvc_remote_storage
	@echo "🧹 Step 6.3: Simulate clean environment and pull data"
	@echo "Removing local cache and data..."
	rm -rf .dvc/cache datadir data/data.xml
	@echo "📥 Pull data from remote:"
	dvc pull -v
	@echo "📁 Verify data is restored:"
	ls datadir data
	@echo "✅ Remote storage setup complete!"

tutorial-advanced: tutorial-remotes ## Advanced data access commands (Section 7)
	@echo "📥 Section 7: Advanced Data Access Commands"
	@echo "🔍 Step 7.1: Explore Remote DVC Repositories"
	dvc list https://github.com/iterative/dataset-registry use-cases
	@echo "📥 Step 7.2: Download Data Without Tracking (dvc get)"
	dvc get https://github.com/iterative/dataset-registry use-cases/cats-dogs -o cats-dogs-untracked
	@echo "📁 Check if it's tracked:"
	ls cats-dogs-untracked
	dvc status
	@echo "📥 Step 7.3: Download and Track Data (dvc import)"
	-dvc import git@github.com:iterative/example-get-started data/data.xml -o imported_data.xml || \
	 dvc import https://github.com/iterative/example-get-started data/data.xml -o imported_data.xml
	@echo "📥 Step 7.4: Track External URLs (dvc import-url)"
	dvc import-url https://data.dvc.org/get-started/data.xml -o external_data.xml
	@echo "📁 Check what was created:"
	ls *.xml* | head -10
	@echo "✅ Advanced data access complete!"

tutorial-pipelines: tutorial-advanced ## Automate model versioning with pipelines (Section 8)
	@echo "🤖 Section 8: Automating Model Versioning with DVC Pipelines"
	@echo "🔄 Ensure we're on cats-dogs-v2 branch with data"
	git checkout cats-dogs-v2
	dvc checkout
	@echo "🧹 Clean up any existing pipeline artifacts"
	-dvc remove model.weights.h5.dvc --force 2>/dev/null || true
	-git rm --cached model.weights.h5.dvc 2>/dev/null || true
	@echo "📝 Step 8.2: Define an ML Pipeline Stage"
	@echo "Creating a simple train.py script for demonstration..."
	@echo '#!/usr/bin/env python3' > train.py
	@echo 'import json' >> train.py
	@echo 'import os' >> train.py
	@echo 'print("Training model with cats-dogs dataset...")' >> train.py
	@echo 'print(f"Dataset size: {len(os.listdir("datadir/data/train/cats")) if os.path.exists("datadir/data/train/cats") else 0} cats")' >> train.py
	@echo 'with open("model.weights.h5", "w") as f: f.write("fake_model_weights")' >> train.py
	@echo 'with open("metrics.csv", "w") as f: f.write("accuracy,0.85\\nloss,0.23")' >> train.py
	@echo 'print("Model saved to model.weights.h5, metrics to metrics.csv")' >> train.py
	chmod +x train.py
	dvc stage add -n train -d train.py -d datadir -o model.weights.h5 -M metrics.csv python train.py
	@echo "👀 Check the generated dvc.yaml:"
	cat dvc.yaml
	git add dvc.yaml
	git commit -m "Define train pipeline stage"
	@echo "🔄 Step 8.3: Reproduce the Pipeline"
	dvc repro
	@echo "📁 Check generated files:"
	ls model.weights.h5 metrics.csv
	@echo "🔄 Run dvc repro again (should show up to date):"
	dvc repro
	@echo "✅ Pipeline automation complete!"

tutorial-full: tutorial-pipelines ## Run the complete tutorial from start to finish
	@echo "🎉 Complete DVC Tutorial finished!"
	@echo "📋 Summary of what was accomplished:"
	@echo "  ✅ Initialized DVC"
	@echo "  ✅ Versioned files and directories"
	@echo "  ✅ Tracked data changes"
	@echo "  ✅ Switched between versions"
	@echo "  ✅ Set up remote storage"
	@echo "  ✅ Used advanced data access"
	@echo "  ✅ Created ML pipelines"
	@echo ""
	@echo "🔍 Current project state:"
	@echo "Git branches:"
	git branch -a
	@echo ""
	@echo "Git tags:"
	git tag
	@echo ""
	@echo "DVC status:"
	dvc status
	@echo ""
	@echo "🎓 Tutorial complete! Check tutorial.md for detailed explanations."

tutorial-reset: tutorial-clean tutorial-init ## Reset and restart tutorial from beginning
	@echo "🔄 Tutorial reset complete! Ready to start fresh with DVC initialized."

tutorial-setup: ## Show tutorial setup and available commands
	@echo "🚀 DVC Tutorial Setup"
	@echo ""
	@echo "Available tutorial commands:"
	@echo "  make tutorial-clean     - Clean up all DVC files and data"
	@echo "  make tutorial-init      - Initialize DVC (Step 1.4)"
	@echo "  make tutorial-file      - Version first dataset file (Section 2)"
	@echo "  make tutorial-directory - Version directory dataset (Section 3)"
	@echo "  make tutorial-changes   - Track changes and updates (Section 4)"
	@echo "  make tutorial-versions  - Switch between versions (Section 5)"
	@echo "  make tutorial-remotes   - Set up remote storage (Section 6)"
	@echo "  make tutorial-advanced  - Advanced data access (Section 7)"
	@echo "  make tutorial-pipelines - ML pipelines (Section 8)"
	@echo "  make tutorial-full      - Run complete tutorial"
	@echo "  make tutorial-reset     - Clean and restart from beginning"
	@echo ""
	@echo "💡 Tip: Run 'make tutorial-full' to execute the entire tutorial automatically!"
	@echo "📖 For detailed explanations, follow along with tutorial.md"
