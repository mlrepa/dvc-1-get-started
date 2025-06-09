# 💻 Development Guide

This guide provides instructions and best practices for developing within this project. Our goal is to maintain high code quality, ensure reproducibility, and make collaboration easier through consistent tooling and workflows.

## 🚀 Getting Started: Environment Setup

To get started, follow the [🚀 Quick Start: Installation & Setup](../README.md#-quick-start-installation--setup) section in the main README.md

## ✨ Code Quality & Consistency

We use a suite of tools to maintain high code quality. Most of these can be run using `make` commands. Configuration for these tools can be found in `pyproject.toml`.

1. **Formatting (Ruff Formatter):** Ensures consistent code style.

- Check formatting: `make format-check`
  - *What it does:* Checks if files adhere to formatting rules without changing them. Fails if reformatting is needed (useful for CI).
  - *Underlying command:* `uv run ruff format --check src/ tests/`

- Apply formatting: `make format`
  - *What it does:* Automatically reformats your code.
  - *Underlying command:* `uv run ruff format src/ tests/`

2. **Linting (Ruff Linter):** Identifies potential bugs, style issues, and anti-patterns.

- Check for linting issues: `make lint`
  - *What it does:* Reports linting errors and warnings.
  - *Underlying command:* `uv run ruff check src/ tests/`
- Attempt to auto-fix linting issues: `make lint-fix` (if available in your Makefile)
  - *What it does:* Fixes many common linting issues automatically.
  - *Underlying command:* `uv run ruff check --fix src/ tests/`

3. **Static Type Checking (Mypy):** Helps catch type-related errors before runtime.

- Run type checks: `make mypy`
  - *What it does:* Analyzes your type hints and reports inconsistencies.
  - *Underlying command:* `uv run mypy src/ tests/`

4. **Combined Auto-Fixing & Formatting:**

- Comprehensive fix: `make autofix` (if available in your Makefile)
  - *What it does:* Typically runs `make lint-fix` and then `make format`. This is often the go-to command before committing.

5. **All Checks (for CI simulation):**

- Run all quality checks: `make check-all` (if available in your Makefile)
  - *What it does:* This should ideally run `make format-check`, `make lint`, and `make mypy`. It simulates what the CI pipeline might do.

## 🧪 Testing with Pytest

We use `pytest` for writing and running unit tests. Tests are located in the `tests/` directory.

1. **Run all tests:** `make test`

- *What it does:* Discovers and runs all tests.
- *Underlying command:* `uv run pytest tests/ -v` (verbosity might vary)

2. **Run tests with code coverage:** `make test-cov`

- *What it does:* Runs tests and generates a report on how much of your code is covered by tests.
- *Underlying command:* `uv run pytest tests/ -v --cov=src --cov-report=xml --cov-report=term-missing` (or similar)

3. **View HTML Coverage Report:** After running `make test-cov` (or `make test` if it includes coverage), open `htmlcov/index.html` in your web browser to see a detailed coverage report.

## 🔄 Typical Development Workflow

1. **(Optional but Recommended) Create a new branch:**

    ```bash
    git checkout main  # Or your development branch like 'dev'
    git pull
    git checkout -b feature/my-new-feature
    ```

2. **Make your code changes** in the `src/` directory and add corresponding tests in `tests/`.
3. **Run linters and formatters frequently:**

    ```bash
    make autofix  # Or run lint-fix and format separately
    ```

4. **Run type checks:**

    ```bash
    make type-check
    ```

5. **Run tests to ensure nothing is broken:**

    ```bash
    make test  # Or make test-cov
    ```

6. **Review changes and stage them:**

    ```bash
    git status
    git add .
    ```

7. **Commit your changes:**

    ```bash
    git commit -m "Your descriptive commit message"
    ```

    - At this point, **pre-commit hooks will run automatically**. If they fail, address the issues, `git add` any modified files again, and re-commit.
8. **Push your branch (if using feature branches):**

    ```bash
    git push origin feature/my-new-feature
    ```

9. **Open a Pull Request** for review if applicable.

## 📦 Managing Dependencies

Project dependencies are managed in `pyproject.toml` under the `[project.dependencies]` and `[project.optional-dependencies]` (e.g., `dev`) sections. `uv.lock` stores the exact versions.

1. **To add a new runtime dependency:**

    ```bash
    uv pip install <package_name>
    ```

    This will update `pyproject.toml` and `uv.lock`.
2. **To add a new development dependency:**

    ```bash
    uv pip install --dev <package_name>
    ```

3. **To update all dependencies to their latest allowed versions and regenerate `uv.lock`:**

    ```bash
    uv pip compile pyproject.toml --all-extras -o uv.lock # Review changes before committing uv.lock
    uv sync --dev # To install based on the new lock file
    ```

    Or, more simply, if you just want to update and install:

    ```bash
    uv pip install -U <package_name> # For a specific package
    uv sync --dev # To update lockfile and install
    ```

    *Always commit your updated `pyproject.toml` and `uv.lock` files together.*

## 🤖 Continuous Integration (CI)

We use GitHub Actions for CI. The workflow is defined in `.github/workflows/ci.yml`. It typically runs `make check-all` (or individual linting, formatting, and testing commands) on every push and pull request to ensure the codebase remains healthy.

---

Happy Developing! If you have questions or suggestions for improving this guide, please let us know.
