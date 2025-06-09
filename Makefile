.PHONY: help install test lint format clean tutorial-clean

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
