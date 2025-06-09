# 🚀 Tutorial: Get started with Data Version Control (DVC)

## 👀 Description

`🎓 What is this?` This tutorial provides hands-on experience with **Data Version Control (DVC)**, demonstrating how to manage multiple datasets and machine learning model artifacts alongside your code. We'll use a classic image classification problem (cats vs. dogs) to illustrate DVC's capabilities for reproducibility and collaboration in MLOps.

`👩‍💻 Who is this for?` ML Engineers, Data Scientists, and AI Developers who need to manage large datasets and models within Git repositories, ensuring experiment reproducibility and traceable deployments. A basic understanding of Python, Git, and command-line operations is assumed.

`🎯 What will you learn?`

- How to initialize a DVC project within a Git repository.
- How to version large files and directories using `dvc add`.
- How DVC tracks data changes using `.dvc` files and a cache.
- How to switch between different versions of your data and models using `dvc checkout`.
- How to set up and use remote storage to store and share DVC-tracked data with `dvc push` and `dvc pull`.
- Advanced data access methods like `dvc get`, `dvc import`, and `dvc import-url`.
- *The fundamentals of DVC pipelines using `dvc stage add` and `dvc repro` for automating ML workflows.*

(This is a conceptual learning objective, even if the dedicated section is removed, as it's a core DVC concept.)

`🔍 How is it structured?` We'll start by setting up our environment and performing basic file and directory versioning. Then, we'll demonstrate tracking changes and switching versions. Next, we'll configure remote storage for sharing data. Finally, we'll cover advanced data access patterns and introduce DVC pipelines for automated model versioning conceptually.

`⏱️ How much time will it take?` Approximately **55-70 minutes** to complete, providing a solid foundation in DVC for your MLOps workflows.

---

## 📖 Table of Contents

- [⚙️ 1. Setting Up Your Environment](#-1-setting-up-your-environment)
  - [Step 1.2: Clone the Project Repository](#-step-12-clone-the-project-repository)
  - [Step 1.3: Initialize Your Python Environment](#-step-13-initialize-your-python-environment)
  - [Step 1.4: Initialize DVC in Your Project](#-step-14-initialize-dvc-in-your-project)
- [⭐ 2. Versioning Your First Dataset (File)](#-2-versioning-your-first-dataset-file)
  - [Step 2.1: Download Raw Data](#-step-21-download-raw-data)
  - [Step 2.2: Add the File to DVC](#-step-22-add-the-file-to-dvc)
  - [Step 2.3: Commit DVC-file to Git](#-step-23-commit-dvc-file-to-git)
- [📁 3. Versioning a Directory (Cats & Dogs Dataset)](#-3-versioning-a-directory-cats--dogs-dataset)
  - [Step 3.1: Create a New Git Branch](#-step-31-create-a-new-git-branch)
  - [Step 3.2: Download the Cats & Dogs Dataset](#-step-32-download-the-cats--dogs-dataset)
  - [Step 3.3: Add the Directory to DVC](#-step-33-add-the-directory-to-dvc)
  - [Step 3.4: Commit the DVC-file and Tag the Version](#-step-34-commit-the-dvc-file-and-tag-the-version)
- [♻️ 4. Tracking Changes & Updating Data](#-4-tracking-changes--updating-data)
  - [Step 4.1: Check Current DVC Status](#-step-41-check-current-dvc-status)
  - [Step 4.2: Introduce a New Data Version](#-step-42-introduce-a-new-data-version)
  - [Step 4.3: Capture the New Data Version with DVC](#-step-43-capture-the-new-data-version-with-dvc)
- [⏪ 5. Switching Between Data Versions (`dvc checkout`)](#-5-switching-between-data-versions-dvc-checkout)
  - [Step 5.1: Switch to a Different Branch (`datadir` Removal)](#-step-51-switch-to-a-different-branch-datadir-removal)
  - [Step 5.2: Restore a Specific Data Version](#-step-52-restore-a-specific-data-version)
- [☁️ 6. Storing and Sharing Data with Remotes](#-6-storing-and-sharing-data-with-remotes)
  - [Step 6.1: Set Up a Local Remote Storage](#-step-61-set-up-a-local-remote-storage)
  - [Step 6.2: Push Data to Remote Storage](#-step-62-push-data-to-remote-storage)
  - [Step 6.3: Retrieve Data from Remote Storage](#-step-63-retrieve-data-from-remote-storage)
- [📥 7. Advanced Data Access Commands](#-7-advanced-data-access-commands)
  - [Step 7.1: Explore Remote DVC Repositories (`dvc list`)](#-step-71-explore-remote-dvc-repositories-dvc-list)
  - [Step 7.2: Download Data Without Tracking (`dvc get`)](#-step-72-download-data-without-tracking-dvc-get)
  - [Step 7.3: Download and Track Data (`dvc import`)](#-step-73-download-and-track-data-dvc-import)
  - [Step 7.4: Track External URLs (`dvc import-url`)](#-step-74-track-external-urls-dvc-import-url)
- [🔍 8. Understanding DVC File and Cache Internals](#-8-understanding-dvc-file-and-cache-internals)
  - [Step 8.1: The `.dvc` File](#-step-81-the-dvc-file)
  - [Step 8.2: The DVC Cache (`.dvc/cache`)](#-step-82-the-dvc-cache-dvc/cache)
  - [Step 8.3: The `.dvc` Directory Structure](#-step-83-the-dvc-directory-structure)
- [🔗 Additional Resources](#-additional-resources)
- [🎉 Conclusion & Next Steps](#-conclusion--next-steps)

---

## ⚙️ 1. Setting Up Your Environment

Let's prepare your system for working with **DVC**.

### Step 1.1: Prerequisites

Make sure you have the following installed:

- **Python 3.8+**: For running the `train.py` script.
- **Git**: Essential for version control of your code and **DVC-files**.
- **DVC (Data Version Control)**: Follow the [official DVC installation instructions](https://dvc.org/doc/install) if you don't have it already.
- **`unzip`**: A command-line tool for extracting `.zip` archives.

### Step 1.2: Clone the Project Repository

We'll start by cloning a ready-made **Git** repository that contains a `train.py` script and `requirements.txt`.

```bash
git clone https://github.com/iterative/example-versioning.git
cd example-versioning
```

**Output (example):**

```
Cloning into 'example-versioning'...
remote: Enumerating objects: 49, done.
...
```

Now, let's create a new **Git** branch for our tutorial work to keep things organized.

```bash
git checkout -b tutorial
```

**Output:**

```
Switched to a new branch 'tutorial'
```

### Step 1.3: Initialize Your Python Environment

It's best practice to use a virtual environment for your **Python** projects to manage dependencies.

1. **Create a virtual environment:**

    ```bash
    python3 -m venv .env
    ```

2. **Activate the virtual environment:**

    - On macOS/Linux:

        ```bash
        source .env/bin/activate
        ```

    - On Windows (Command Prompt):

        ```bash
        .env\Scripts\activate.bat
        ```

    - On Windows (PowerShell):

        ```bash
        .env\Scripts\Activate.ps1
        ```

    You should see `(.env)` prepended to your command prompt, indicating the virtual environment is active.

3. **Install project requirements:**

    ```bash
    pip install -r requirements.txt
    ```

    This might take a few minutes as it installs libraries like **TensorFlow**/ **Keras** for the dummy model.

### Step 1.4: Initialize DVC in Your Project

The first step in any **DVC** project is to initialize it within your **Git** repository.

```bash
dvc init
```

**Output:**

```
Initialized DVC repository.
You can now add your first data file or folder to DVC:
 dvc add <filename|dirname>

...
```

Let's see what DVC initialization has done:

```bash
ls -la .dvc/
```

**Output (example):**

```
total 8
drwxr-xr-x 4 user user 4096 Apr  1 10:00 .
drwxr-xr-x 8 user user 4096 Apr  1 10:00 ..
-rw-r--r-- 1 user user  122 Apr  1 10:00 config
drwxr-xr-x 2 user user 4096 Apr  1 10:00 tmp
-rw-r--r-- 1 user user    8 Apr  1 10:00 .gitignore
```

**DVC** creates a `.dvc/` directory and populates it with internal files. The most important one right now is `.dvc/config`, which stores **DVC**'s settings. It also creates a `.dvc/.gitignore` file to ensure **Git** ignores **DVC**'s internal **cache**.

Now, let's add these **DVC**-related files to **Git** and commit them. This ties your **DVC** setup to your **Git** repository.

```bash
git status
```

**Output (example):**

```
On branch tutorial
...
Untracked files:
  (use "git add <file>..." to include in what will be committed)
 .dvc/
```

```bash
git add .dvc/
git commit -m "Initialize DVC"
```

**Output:**

```
[tutorial 0c7d42a] Initialize DVC
 2 files changed, 5 insertions(+)
 create mode 100644 .dvc/.gitignore
 create mode 100644 .dvc/config
```

---

## ⭐ 2. Versioning Your First Dataset (File)

Now that **DVC** is set up, let's learn how to track individual files. We'll start with a simple XML dataset.

### Step 2.1: Download Raw Data

We'll download a small `data.xml` file. Notice the `-o data/data.xml` flag, which specifies the output path.

```bash
dvc get https://github.com/iterative/dataset-registry get-started/data.xml -o data/data.xml
```

**Output:**

```
100%|█████████████████████████████████████████████████████████████████████████████████████| 2.72K/2.72K [00:00]
```

`dvc get` is like `wget` or `curl` but specifically designed to download files tracked by **DVC** (or **Git**) repositories.

### Step 2.2: Add the File to DVC

Now, let's tell **DVC** to track this `data.xml` file.

```bash
dvc add data/data.xml -v
```

**Output (example):**

```
Added 'data/data.xml' to DVC cache.
To share it, run 'dvc push'.
To put it under Git version control, run 'git add data/data.xml.dvc'.
```

What happened?

- **DVC** moved the actual `data.xml` file into its **cache** (located in `.dvc/cache`).
- It replaced the original `data.xml` with a small **`.dvc` file** (specifically, `data/data.xml.dvc`). This `.dvc` file is a plain text file that acts as a pointer to the data's content in the **DVC cache**.
- **DVC** also automatically created `data/.gitignore` to tell **Git** to ignore the actual `data.xml` content, only tracking the `.dvc` pointer file.

Let's inspect the `.dvc` file:

```bash
cat data/data.xml.dvc
```

**Output (example):**

```
outs:
- md5: a304afb96060aad90176268345e10355
  path: data.xml
  size: 2785
```

This `.dvc` file contains metadata about the data: an **MD5 hash** of its content, its path, and its size. The **MD5 hash** is crucial as it uniquely identifies the data's content in the **DVC cache**.

### Step 2.3: Commit DVC-file to Git

Since `data.xml.dvc` is just a small text file, we can commit it to **Git**. This links the specific version of your data to your **Git** commit history.

```bash
git add data/.gitignore data/data.xml.dvc
git commit -m "Add raw data.xml"
```

**Output:**

```
[tutorial 4d0e7f7] Add raw data.xml
 2 files changed, 6 insertions(+)
 create mode 100644 data/.gitignore
 create mode 100644 data/data.xml.dvc
```

Now, your **Git** repository tracks the *metadata* about your data, while **DVC** manages the large data content efficiently.

---

## 📁 3. Versioning a Directory (Cats & Dogs Dataset)

**DVC** excels at versioning entire directories containing many files, which is common for image datasets.

### Step 3.1: Create a New Git Branch

Let's create a new **Git** branch to track our first version of the cats and dogs dataset.

```bash
git checkout -b cats-dogs-v1
```

**Output:**

```
Switched to a new branch 'cats-dogs-v1'
```

### Step 3.2: Download the Cats & Dogs Dataset

We'll download a larger dataset consisting of cat and dog images into a directory named `datadir`. We're using `dvc get --rev` to specify a particular version of the dataset from the remote **DVC** repository.

```bash
dvc get --rev cats-dogs-v1 https://github.com/iterative/dataset-registry use-cases/cats-dogs -o datadir
```

**Output (example):**

```
100%|█████████████████████████████████████████████████████████████████████████████████████| 67.5M/67.5M [00:03]
```

This command downloads the dataset, which includes `train` and `validation` subdirectories for cats and dogs images.

Let's confirm some files are there:

```bash
ls datadir/data/train/cats
```

**Output (example):**

```
cat.1.jpg  cat.10.jpg  cat.100.jpg ... cat.999.jpg
```

### Step 3.3: Add the Directory to DVC

Now, add the entire `datadir` to **DVC**.

```bash
dvc add datadir
```

**Output (example):**

```
Added 'datadir' to DVC cache.
To share it, run 'dvc push'.
To put it under Git version control, run 'git add datadir.dvc'.
```

Similar to adding a file, `dvc add` moves the `datadir` content to the **DVC cache** and creates `datadir.dvc`. For directories, **DVC** creates a special `.dir` file in its **cache** that lists the hashes of all files and subdirectories within the tracked directory. This allows efficient versioning of large folder structures.

Inspect the `.dvc` file for the directory:

```bash
cat datadir.dvc
```

**Output (example):**

```
outs:
- md5: b6923e1e4ad16ea1a7e2b328842d56a2.dir
  path: datadir
```

Notice the `.dir` suffix on the **MD5 hash**, indicating it refers to a directory hash.

### Step 3.4: Commit the DVC-file and Tag the Version

Commit the `datadir.dvc` file to **Git** and add a **Git** tag to mark this specific data version.

```bash
git add .gitignore datadir.dvc # .gitignore is created by DVC when adding a dir
git commit -m "Add cats-dogs dataset (v1)"
git tag -a cats-dogs-v1 -m "Dataset version v1.0"
```

**Output:**

```
[cats-dogs-v1 2a3b4c5] Add cats-dogs dataset (v1)
 2 files changed, 4 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 datadir.dvc
```

You now have a **Git** tag `cats-dogs-v1` that points to a specific version of your `datadir` dataset!

---

## ♻️ 4. Tracking Changes & Updating Data

One of **DVC**'s core strengths is detecting and tracking changes to your data.

### Step 4.1: Check Current DVC Status

Use `dvc status` to see the state of your **DVC**-tracked files.

```bash
dvc status
```

**Output:**

```
Data and pipelines are up to date.
```

This indicates that all **DVC**-tracked data in your workspace matches what **DVC** expects (i.e., the content pointed to by the `.dvc` files in your current **Git** commit).

### Step 4.2: Introduce a New Data Version

Let's simulate an update where our `cats-dogs` dataset doubles in size (e.g., new images added after more data collection). We'll switch to a new **Git** branch first.

```bash
git checkout -b cats-dogs-v2
```

**Output:**

```
Switched to a new branch 'cats-dogs-v2'
```

Now, download the updated dataset version. This will overwrite the `datadir` in your workspace.

```bash
dvc get --rev cats-dogs-v2 https://github.com/iterative/dataset-registry use-cases/cats-dogs -o datadir
```

**Output (example):**

```
100%|█████████████████████████████████████████████████████████████████████████████████████| 90.7M/90.7M [00:04]
```

The `datadir` in your project now contains the "v2" version of the data.

Let's check `dvc status` again:

```bash
dvc status
```

**Output (example):**

```
? datadir
```

The `?` indicates that `datadir` exists in your workspace but is **not tracked by DVC's current `.dvc` file**. **DVC** recognizes that the content of `datadir` has changed since the last `dvc add` operation.

### Step 4.3: Capture the New Data Version with DVC

To capture this new version of the data, we simply run `dvc add` again.

```bash
dvc add datadir
```

**Output (example):**

```
M       datadir
Updated 'datadir' in DVC cache.
To share it, run 'dvc push'.
To put it under Git version control, run 'git add datadir.dvc'.
```

**DVC** detects the change, updates its **cache**, and modifies `datadir.dvc` to point to the new content hash.

Now, commit the updated `datadir.dvc` file to **Git** and tag it as `cats-dogs-v2`.

```bash
git add datadir.dvc
git commit -m "Updated cats-dogs dataset (v2)"
git tag -a cats-dogs-v2 -m "Dataset version v2.0"
```

**Output:**

```
[cats-dogs-v2 b7d8e9f] Updated cats-dogs dataset (v2)
 1 file changed, 2 insertions(+), 2 deletions(-)
```

You now have two distinct versions of your dataset (`cats-dogs-v1` and `cats-dogs-v2`) linked to different **Git** tags, all managed efficiently by **DVC**.

---

## ⏪ 5. Switching Between Data Versions (`dvc checkout`)

The power of **DVC** comes from its ability to quickly switch between different versions of your data, just like **Git** switches code versions.

### Step 5.1: Switch to a Different Branch (`datadir` Removal)

Let's switch back to our initial `tutorial` branch, which does *not* contain the `datadir.dvc` file in its **Git** history.

```bash
git checkout tutorial
```

**Output:**

```
Switched to branch 'tutorial'
Your branch is up to date with 'origin/tutorial'.
```

Now, check your files:

```bash
ls
```

**Output (example):**

```
.dvc  .env  data  main.py  requirements.txt  train.py
```

Notice that `datadir` is gone from your workspace! This is because the `tutorial` branch's **Git** history doesn't track `datadir.dvc`.

To ensure your workspace accurately reflects the **DVC-tracked data** for the *current Git commit*, you need to run `dvc checkout`. This command will synchronize your workspace with the **DVC cache** based on the `.dvc` files that are currently in your **Git** index.

```bash
dvc checkout
```

**Output:**

```
M       data/data.xml
D       datadir
```

What happened?

- `M data/data.xml`: If the `data/data.xml` in your workspace (from previous steps) was different from what `data/data.xml.dvc` (tracked on `tutorial` branch) points to, **DVC** updated it.
- `D datadir`: Since the `tutorial` branch's **Git** history *does not* include `datadir.dvc`, **DVC** recognized that the physical `datadir` directory in your workspace was no longer tracked by **DVC** for this **Git** commit. Thus, **DVC** **deleted** `datadir` from your workspace to keep it clean and consistent with the current **Git** branch's data versioning state.

This demonstrates how **DVC** intelligently removes untracked (by **DVC**) data from your workspace when you switch to a **Git** commit that doesn't expect it.

Let's specifically try to restore the `cats-dogs-v1` version.

### Step 5.2: Restore a Specific Data Version

We want to get back the `cats-dogs-v1` dataset. First, switch your **Git** repository to that version's tag.

```bash
git checkout cats-dogs-v1
```

**Output:**

```
Note: switching to 'cats-dogs-v1'.
...
HEAD is now at 2a3b4c5... Add cats-dogs dataset (v1)
```

Now, if you check your files:

```bash
ls
```

**Output (example):**

```
.dvc  .env  data  datadir  main.py  requirements.txt  train.py
```

`datadir` is there, but its content is likely the `v2` content you just had. Why? Because `git checkout` only updates the `.dvc` *pointer files* in your workspace. It does *not* automatically fetch the actual data content. That's **DVC**'s job!

To truly bring the `cats-dogs-v1` data content into your workspace, you must run `dvc checkout`:

```bash
dvc checkout
```

**Output:**

```
M       datadir
```

`M` indicates that `datadir` was modified (i.e., its content was swapped to the `v1` version). Now, your workspace's `datadir` should match the `cats-dogs-v1` content.

```bash
ls datadir/data/train/dogs | head -n 5
```

You can verify the number of files or file names to ensure you are on `v1` (e.g., v1 had 500 dogs, v2 had 1000). This demonstrates that **DVC** efficiently retrieves the correct data version from its **cache** without re-downloading or copying large files unnecessarily.

---

## ☁️ 6. Storing and Sharing Data with Remotes

**DVC**'s **cache** stores data locally. To share data with your team or deploy models, you need a **remote storage** location. This can be cloud storage (**S3**, **GCS**, **Azure Blob**), network file systems, or even a local directory.

### Step 6.1: Set Up a Local Remote Storage

For simplicity in this tutorial, we'll set up a local directory as our **DVC remote**. In a real-world scenario, this would be cloud storage.

```bash
mkdir -p /tmp/dvc_remote_storage
dvc remote add -d local_storage /tmp/dvc_remote_storage
```

**Output (example):**

```
Setting 'local_storage' as a default remote.
```

- **`mkdir -p /tmp/dvc_remote_storage`**: Creates a temporary directory.
    👉 **IMPORTANT:** In a real project, **NEVER** use `/tmp` for long-term storage, as it's frequently cleared by your system. Use a persistent directory or, ideally, cloud storage.
- **`dvc remote add -d local_storage /tmp/dvc_remote_storage`**: Tells **DVC** about a new **remote** named `local_storage` and sets it as the default (`-d`).

This command modifies your `.dvc/config` file. Let's see:

```bash
cat .dvc/config
```

**Output (example):**

```
['core']
 remote = local_storage
['remote "local_storage"']
 url = /tmp/dvc_remote_storage
```

Now, commit this configuration change to **Git** so your team knows where the data is supposed to be stored.

```bash
git add .dvc/config
git commit -m "Add local DVC remote storage"
```

**Output:**

```
[cats-dogs-v1 8e9f0a1] Add local DVC remote storage
 1 file changed, 3 insertions(+)
```

### Step 6.2: Push Data to Remote Storage

To upload the **DVC**-tracked data from your local **cache** to the configured **remote**, use `dvc push`.

```bash
dvc push -v
```

**Output (example, showing data being pushed):**

```
Preparing to push data.
...
Pushing 'datadir' to 'local_storage'
100%|█████████████████████████████████████████████████████████████████████████████████████| 10/10 [00:00]
...
Pushed data to 'local_storage'.
```

**DVC** only pushes the actual data content, not the `.dvc` pointer files (which are in **Git**). It's intelligent enough to only upload data that isn't already present in the **remote storage**.

You can verify the data was pushed by checking the **remote** directory (it mirrors **DVC**'s **cache** structure):

```bash
ls /tmp/dvc_remote_storage
```

**Output (example):**

```
a3 b6
```

These are directories named after the first two characters of the data's **MD5 hashes**.

### Step 6.3: Retrieve Data from Remote Storage

Now, let's simulate a scenario where a new team member joins or you're working on a new machine. The data isn't in your local **DVC cache**.

1. **Remove local cache and data:**

    ```bash
    rm -rf .dvc/cache
    rm -rf datadir
    rm -rf data/data.xml # Clean up the individual file too
    ```

    Your workspace should now be clean of the actual data files.

2. **Pull data from the remote:**

    ```bash
    dvc pull -v
    ```

    **Output (example):**

    ```
    Preparing to pull data.
    ...
    100%|█████████████████████████████████████████████████████████████████████████████████████| 2/2 [00:00]
    Pulled data to 'local_storage'.
    ```

    `dvc pull` checks the `.dvc` files in your current **Git** commit, looks up the corresponding data hashes in the **remote**, downloads them to your local **DVC cache**, and then links them back into your workspace.

    Verify that your data is back:

    ```bash
    ls datadir
    ls data
    ```

    You should see both `datadir` and `data/data.xml` restored. This demonstrates how **DVC** enables seamless data sharing and environment setup for collaborative **ML** projects.

---

## 📥 7. Advanced Data Access Commands

**DVC** offers more specialized commands for accessing and incorporating data from other **DVC** repositories or external **URLs**.

### Step 7.1: Explore Remote DVC Repositories (`dvc list`)

You can explore the contents of any **DVC** repository hosted on a **Git** server without cloning it first.

```bash
dvc list https://github.com/iterative/dataset-registry use-cases
```

**Output (example):**

```
cats-dogs/
get-started/
```

This shows the directories available under the `use-cases` path in that **DVC** dataset registry.

### Step 7.2: Download Data Without Tracking (`dvc get`)

You've already used `dvc get` earlier. It downloads data from a **DVC remote** repository to your current working directory, but it **does not** automatically add the downloaded data to *your* **DVC** project.

Let's get `cats-dogs` again, but this time, into a new folder to confirm it's not **DVC**-tracked locally:

```bash
dvc get https://github.com/iterative/dataset-registry use-cases/cats-dogs -o cats-dogs-untracked
```

**Output (example):**

```
100%|█████████████████████████████████████████████████████████████████████████████████████| 90.7M/90.7M [00:04]
```

```bash
ls
```

You'll see `cats-dogs-untracked` directory. If you check `dvc status` or look for a `cats-dogs-untracked.dvc` file, you won't find one. This is useful when you just need a copy of data for temporary exploration or a one-off task.

### Step 7.3: Download and Track Data (`dvc import`)

`dvc import` is like `dvc get` followed by `dvc add`. It downloads data from another **DVC** repository *and* automatically registers it with your local **DVC** project, creating a `.dvc` file for it.

```bash
dvc import git@github.com:iterative/example-get-started data/data.xml -o imported_data.xml
```

**Output (example):**

```
Importing 'data/data.xml' from 'git@github.com:iterative/example-get-started'.
100%|█████████████████████████████████████████████████████████████████████████████████████| 2.72K/2.72K [00:00]
```

Now, check your directory:

```bash
ls
cat imported_data.xml.dvc
```

You'll see `imported_data.xml` and its corresponding `imported_data.xml.dvc` file, indicating it's now tracked by your **DVC** project.

### Step 7.4: Track External URLs (`dvc import-url`)

`dvc import-url` allows you to track data directly from an external **URL** (**HTTP/HTTPS**, **S3**, **GCS**, **Azure Blob**, etc.) into your **DVC** project. It downloads the data and creates a `.dvc` file for it. This is useful for managing external datasets that you don't control.

```bash
dvc import-url https://data.dvc.org/get-started/data.xml -o external_data.xml
```

**Output (example):**

```
100%|█████████████████████████████████████████████████████████████████████████████████████| 2.72K/2.72K [00:00]
```

You will find `external_data.xml` and `external_data.xml.dvc` in your project. If the data at the **URL** changes, `dvc update external_data.xml.dvc` (or `dvc pull`) can pull the new version.

---

## 🔍 8. Understanding DVC File and Cache Internals

Let's take a closer look at the files and directories **DVC** creates and manages, which underpin its versioning capabilities.

### Step 8.1: The `.dvc` File

We've already seen examples like `data/data.xml.dvc` and `datadir.dvc`. These are small **YAML** files that act as pointers to the actual data content, which lives in **DVC**'s **cache**.

For a single file (`data/data.xml.dvc`), the `.dvc` file usually contains:

- `md5`: An **MD5 hash** of the file's content. This uniquely identifies the file.
- `path`: The relative path to the data file in the workspace.
- `size`: The size of the data file in bytes.

For a directory (`datadir.dvc`), the `md5` field will end with `.dir`, indicating that the hash represents the content of the entire directory, not a single file. This "directory hash" is calculated based on the hashes of all files and subdirectories within it.

### Step 8.2: The DVC Cache (`.dvc/cache`)

The `.dvc/cache` directory is where **DVC** stores the actual content of your data and model files.

```bash
ls -la .dvc/cache
```

**Output (example):**

```
drwxr-xr-x 4 user user 4096 Apr  1 10:00 .
drwxr-xr-x 8 user user 4096 Apr  1 10:00 ..
drwxr-xr-x 2 user user 4096 Apr  1 10:00 a3
drwxr-xr-x 2 user user 4096 Apr  1 10:00 b6
```

Inside `.dvc/cache`, **DVC** organizes files based on their **MD5 hash**. The first two characters of the hash form a subdirectory, and the rest become the filename within that subdirectory. This helps to prevent too many files in one directory and makes lookup efficient.

For example, if your `data.xml` had an **MD5 hash** starting with `a3`, its content would be stored in `.dvc/cache/a3/04afb96060aad90176268345e10355`. If `datadir` had a directory hash starting with `b6`, its metadata (listing hashes of its contents) would be in `.dvc/cache/b6/923e1e4ad16ea1a7e2b328842d56a2.dir`.

**Key Advantage:** If you have multiple **DVC**-tracked files with different names but *identical content*, **DVC** only stores one copy of that content in the **cache**, saving disk space.

### Step 8.3: The `.dvc` Directory Structure

The `.dvc/` directory is **DVC**'s internal workspace for your project.

```bash
ls -la .dvc
```

**Output (example):**

```
drwxr-xr-x 9 user user 4096 Apr  1 10:00 .
drwxr-xr-x 8 user user 4096 Apr  1 10:00 ..
-rw-r--r-- 1 user user  122 Apr  1 10:00 config
drwxr-xr-x 2 user user 4096 Apr  1 10:00 cache
-rw-r--r-- 1 user user    8 Apr  1 10:00 .gitignore
drwxr-xr-x 2 user user 4096 Apr  1 10:00 tmp
# Other directories may appear depending on DVC version and features used:
# plots/, experiments/ etc.
```

- `.dvc/config`: Main **DVC** configuration (**remotes**, **cache** location, etc.).
- `.dvc/cache`: Where actual data/model content is stored.
- `.dvc/.gitignore`: Ensures **Git** ignores the **cache** and other **DVC internal files**.
- `.dvc/tmp`: Temporary files used by **DVC**.
- Other directories like `.dvc/plots` or `.dvc/experiments` might appear if you use **DVC**'s plotting or experiment management features.

Understanding these internals helps you grasp how **DVC** efficiently links your **Git**-versioned code with your large, **DVC**-versioned data and models.

---

## 🔗 Additional Resources

- **DVC Official Documentation:** [https://dvc.org/doc](https://dvc.org/doc)
- **DVC Get Started:** [https://dvc.org/doc/start](https://dvc.org/doc/start)
- **DVC User Guide (Files & Directories):** [https://dvc.org/doc/user-guide/dvc-files-and-directories](https://dvc.org/doc/user-guide/dvc-files-and-directories)
- **DVC Get Started: Data Pipelines:** [https://dvc.org/doc/start/data-pipelines](https://dvc.org/doc/start/data-pipelines)
- **Example: Tracking a remote file (for `dvc import-url`):** [https://dvc.org/doc/command-reference/import-url](https://dvc.org/doc/command-reference/import-url)

---

## 🎉 Conclusion & Next Steps

Congratulations! You've successfully completed this hands-on tutorial on Data and Model Versioning with **DVC**.

### Key Learnings

- You've learned how to initialize **DVC** and version large files and directories alongside your **Git** repository.
- You now understand the crucial role of `.dvc` files and the **DVC cache** in maintaining data integrity and reproducibility.
- You've mastered how to switch between different data versions and how to efficiently share data using **DVC remotes**.
- You've gained an initial understanding of **DVC pipelines**, which allow you to track and reproduce entire **ML workflows**.

### Where to go from here?

- **Experiment Management (MLflow):** Explore how **DVC** integrates with **MLflow** for comprehensive experiment tracking, logging **metrics**, and managing models in a registry.
- **Continuous Integration/Delivery for ML (CI/CD for MLOps):** Learn how to set up **CI/CD pipelines** that leverage **DVC**'s `dvc repro` to automate model retraining, evaluation, and deployment upon code or data changes.
- **Advanced DVC Features:** Dive deeper into **DVC**'s capabilities for **metrics** and plots tracking, experiment versioning (`dvc exp`), and managing more complex data **dependencies**.
- **Cloud Remotes:** Transition from local **DVC remotes** to cloud storage solutions (**AWS S3**, **Google Cloud Storage**, **Azure Blob Storage**) for real-world production deployments.

Keep practicing these **MLOps** fundamentals. The ability to version, reproduce, and share your data and models reliably is a superpower in modern **AI** development!

[⬆️ Back to Table of Contents](#-table-of-contents)
