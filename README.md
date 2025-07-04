# 🚀 Tutorial: Data and Model Versioning with DVC

**🎓 What is this?** This tutorial provides hands-on experience with **Data Version Control (DVC)**, demonstrating how to manage multiple datasets and machine learning model artifacts alongside your code. We'll use a classic image classification problem (cats vs. dogs) to illustrate DVC's capabilities for reproducibility and collaboration in MLOps.

**👩‍💻 Who is this for?** ML Engineers, Data Scientists, and AI Developers who need to manage large datasets and models within Git repositories, ensuring experiment reproducibility and traceable deployments. A basic understanding of Python, Git, and command-line operations is assumed.

**🎯 What will you learn?**

- How to initialize a DVC project within a Git repository.

* How to version large files and directories using `dvc add`.
- How DVC tracks data changes using `.dvc` files and a cache.
- How to switch between different versions of your data and models using `dvc checkout`.
- How to set up and use remote storage to store and share DVC-tracked data with `dvc push` and `dvc pull`.
- Advanced data access methods like `dvc get`, `dvc import`, and `dvc import-url`.
- The fundamentals of DVC pipelines using `dvc stage add` and `dvc repro` for automating ML workflows.

## 📂 Project Structure

```text
mlops-get-started-iris/
├── .github/                # GitHub specific configurations (e.g., Workflows for CI)
├── docs/
│   └── DEVELOPMENT.md      # Detailed guide for developers on coding standards and tools
├── .gitignore              # Global Git ignore patterns for the project
├── .pre-commit-config.yaml # Configuration for pre-commit hooks (Ruff, Mypy, etc.)
├── .python-version         # Specifies the preferred Python version (e.g., for pyenv or uv)
├── .secrets.baseline       # Baseline file for detect-secrets (prevents committing secrets)
├── Makefile                # Defines useful development commands (e.g., make lint, make test)
├── pyproject.toml          # Project configuration, dependencies, and tool settings (PEP 621)
└── uv.lock                 # Lock file for reproducible Python dependencies (generated by uv)
```

## 🛠️ Prerequisites

Ensure you have the following installed on your system:

- **Python 3.11+**: We recommend using the version specified in the `.python-version` file.
- **`uv`**: A fast Python package installer and project manager. See the [uv installation guide](https://docs.astral.sh/uv/getting-started/installation/).

## 🚀 Quick Start: Installation & Setup

1. **Clone the Repository:**

    ```bash
    git clone <YOUR_REPOSITORY_URL>
    cd dvc-1-get-started
    ```

2. **Set Up Python Environment**

    ```bash
    # Create a virtual environment (e.g., named .venv) using the project's Python version
    uv venv .venv --python 3.12

    # Activate the virtual environment:
    # On macOS and Linux:
    source .venv/bin/activate
    # On Windows (PowerShell):
    # .\.venv\Scripts\Activate.ps1
    # On Windows (Command Prompt):
    # .\.venv\Scripts\activate.bat

    ```

3. **Install Dependencies:**
    We'll use `uv` to create a virtual environment and install dependencies.

    ```bash
    # Install project dependencies, including development tools:
    uv sync --dev

    # Initialize Pre-commit Hooks
    uv run pre-commit install
    ```

    Alternatively, the `Makefile` provides a shortcut:

    ```bash
    make install # This target in the Makefile should execute the uv commands above
    ```

You're now ready to start!

# ▶️ Running the Tutorial

Open the `tutorial.md` file to start the tutorial.

## 💻 Development Workflow & Tools

For a deeper dive into the development workflow, tool configurations, and contribution guidelines, please consult the [DEVELOPMENT.md](docs/DEVELOPMENT.md) file.

---

**Happy DVC journey! 🚀**
