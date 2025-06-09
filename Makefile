.PHONY: help install test lint format clean run-pipeline tutorial-setup tutorial-clean tutorial-init tutorial-file tutorial-directory tutorial-changes tutorial-versions tutorial-remotes tutorial-advanced tutorial-pipelines tutorial-full tutorial-reset

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
	@# Remove Git branches created during tutorial
	@echo "Switching to a safe branch before cleanup..."
	@if git show-ref --verify --quiet refs/heads/main; then \
		git checkout main; \
	elif git show-ref --verify --quiet refs/heads/master; then \
		git checkout master; \
	else \
		git checkout -b cleanup-temp; \
	fi
	@echo "Removing tutorial branches..."
	@for branch in cats-dogs-v1 cats-dogs-v2 tutorial cleanup-temp; do \
		if git show-ref --verify --quiet refs/heads/$$branch && [ "$$branch" != "$$(git branch --show-current)" ]; then \
			echo "Deleting branch $$branch"; \
			git branch -D $$branch 2>/dev/null || true; \
		fi; \
	done
	@echo "✅ DVC tutorial cleanup complete! Repository reset to initial state."

dvc-init: ## Initialize DVC in the project (Step 1.4)
	@echo "🌿 Step 1.4: Init project in 'tutorial' branch"
	@if git show-ref --verify --quiet refs/heads/tutorial; then \
		echo "Branch 'tutorial' exists, switching to it"; \
		git checkout tutorial; \
	else \
		echo "Creating new branch 'tutorial'"; \
		git checkout -b tutorial; \
	fi
	@echo "🚀 Step 1.4: Initialize DVC in Your Project"
	dvc init
	@echo "📁 DVC initialized! Let's see what was created:"
	ls -la .dvc/
	@echo "📝 Adding DVC files to Git..."
	git add .dvc/
	git commit -m "Initialize DVC"
	@echo "✅ DVC initialization complete!"

dvc-track-file:  ## Version your first dataset file (Section 2)
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

dvc-track-directory: ## Version a directory dataset (Section 3)
	@echo "📁 Section 3: Versioning a Directory (Cats & Dogs Dataset)"
	@echo "🌿 Step 3.1: Create a New Git Branch"
	@if git show-ref --verify --quiet refs/heads/cats-dogs-v1; then \
		echo "Branch 'cats-dogs-v1' exists, switching to it"; \
		git checkout cats-dogs-v1; \
	else \
		echo "Creating new branch 'cats-dogs-v1'"; \
		git checkout -b cats-dogs-v1; \
	fi
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

dvc-track-changes: ## Track changes and update data (Section 4)
	@echo "♻️ Section 4: Tracking Changes & Updating Data"
	@echo "🔍 Step 4.1: Check Current DVC Status"
	dvc status
	@echo "🌿 Step 4.2: Introduce a New Data Version"
	@if git show-ref --verify --quiet refs/heads/cats-dogs-v2; then \
		echo "Branch 'cats-dogs-v2' exists, switching to it"; \
		git checkout cats-dogs-v2; \
	else \
		echo "Creating new branch 'cats-dogs-v2'"; \
		git checkout -b cats-dogs-v2; \
	fi
	dvc get --rev cats-dogs-v2 https://github.com/iterative/dataset-registry use-cases/cats-dogs -o datadir
	@echo "🔍 Check status after data change:"
	dvc status
	@echo "📝 Step 4.3: Capture the New Data Version with DVC"
	dvc add datadir
	git add datadir.dvc
	git commit -m "Updated cats-dogs dataset (v2)"
	git tag -a cats-dogs-v2 -m "Dataset version v2.0"
	@echo "✅ Change tracking complete!"

dvc-switch-versions: ## Switch between data versions (Section 5)
	@echo "⏪ Section 5: Switching Between Data Versions"
	@echo "🔄 Step 5.1: Switch to Different Branch"
	@if git show-ref --verify --quiet refs/heads/tutorial; then \
		git checkout tutorial; \
	elif git show-ref --verify --quiet refs/heads/main; then \
		git checkout main; \
	elif git show-ref --verify --quiet refs/heads/master; then \
		git checkout master; \
	else \
		echo "No suitable branch found, staying on current branch"; \
	fi
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

dvc-add-remotes:  ## Set up and use remotes (Section 6)
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

dvc-advanced:  ## Advanced data access commands (Section 7)
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


dvc-full: dvc-init dvc-track-file dvc-track-directory dvc-track-changes dvc-switch-versions dvc-add-remotes dvc-advanced
	@echo "🎉 Complete DVC Tutorial finished!"
	@echo "📋 Summary of what was accomplished:"
	@echo "  ✅ Initialized DVC"
	@echo "  ✅ Versioned files and directories"
	@echo "  ✅ Tracked data changes"
	@echo "  ✅ Switched between versions"
	@echo "  ✅ Set up remote storage"
	@echo "  ✅ Used advanced data access"


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
	@echo "  make tutorial-full      - Run complete tutorial"
	@echo ""
	@echo "💡 Tip: Run 'make tutorial-full' to execute the entire tutorial automatically!"
	@echo "📖 For detailed explanations, follow along with tutorial.md"
