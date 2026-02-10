# Scripts

This directory contains utility scripts for the Exo Holdout project.

## create_backlog_issues.py

Automatically creates GitHub issues from the tasks listed in `docs/backlog.md`.

### Prerequisites

- Python 3.6 or higher
- GitHub CLI (`gh`) installed and authenticated
- Write access to the repository

### Installation

1. Install GitHub CLI if you haven't already:
   ```bash
   # macOS
   brew install gh
   
   # Windows
   winget install --id GitHub.cli
   
   # Linux
   sudo apt install gh  # Debian/Ubuntu
   ```

2. Authenticate with GitHub:
   ```bash
   gh auth login
   ```

### Usage

#### Preview Issues (Dry Run)

To see what issues will be created without actually creating them:

```bash
python scripts/create_backlog_issues.py --dry-run
```

#### Create Issues

To create all issues from the backlog:

```bash
python scripts/create_backlog_issues.py
```

#### Create Issues and Add to Project

To create issues and add them to a GitHub Project board:

```bash
python scripts/create_backlog_issues.py --project "Exo Holdout"
```

**Note:** 
- Replace "Exo Holdout" with the exact name of your GitHub Project.
- Issues will be added to the project, but the specific column placement depends on your project's configuration and automation rules.

#### Advanced Options

```bash
python scripts/create_backlog_issues.py --help
```

Available options:
- `--dry-run`: Preview issues without creating them
- `--project PROJECT_NAME`: Add issues to specified GitHub Project (in the backlog column)
- `--repo REPO`: Specify repository (default: obscurelyme/exo-holdout)
- `--backlog PATH`: Path to backlog file (default: docs/backlog.md)

### What It Does

1. **Parses** `docs/backlog.md` to extract all tasks from the "To Do" section
2. **Extracts** task information including:
   - Task title
   - Category (e.g., Core Systems, Networking & Multiplayer)
   - Time estimate
   - Subtasks/checklist items
3. **Creates** GitHub labels for each category if they don't exist
4. **Creates** GitHub issues with:
   - Title from the task name
   - Body containing category, time estimate, and subtasks as a checklist
   - Label based on the category
5. **Optionally adds** issues to a GitHub Project board (column placement depends on project automation rules)

### Example Output

```
Parsing backlog from: /home/runner/work/exo-holdout/exo-holdout/docs/backlog.md
Found 44 tasks

Ensuring labels exist: core-systems, networking--multiplayer, player-systems, ...

Creating issues...
✓ Created issue: Setup Godot Project Structure
  URL: https://github.com/obscurelyme/exo-holdout/issues/1
  ✓ Added to project: Exo Holdout
✓ Created issue: Implement Game State Manager
  URL: https://github.com/obscurelyme/exo-holdout/issues/2
  ✓ Added to project: Exo Holdout
...

================================================================================
Successfully created 44 issues
================================================================================
```

### Troubleshooting

**Error: "You are not logged into any GitHub hosts"**
- Run `gh auth login` to authenticate with GitHub

**Error: "Resource not accessible by integration"**
- Ensure you have write access to the repository
- Verify the repository name is correct

**Error: "Project not found"**
- Check that the project name is exactly correct (case-sensitive)
- Ensure the project exists in the repository or organization

**Issues created but not added to project**
- Verify the project name matches exactly
- Check that you have permission to manage the project
- The script will create issues even if adding to project fails

### Notes

- The script will create labels automatically if they don't exist
- All labels are created with a light purple color (#D4C5F9)
- Each issue references the original backlog file in its description
- Issues are created sequentially to avoid rate limiting
