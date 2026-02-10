#!/usr/bin/env python3
"""
Script to create GitHub issues from docs/backlog.md

This script parses the backlog markdown file and creates GitHub issues
for each task using the GitHub CLI (gh).

Usage:
    python scripts/create_backlog_issues.py --dry-run  # Preview issues
    python scripts/create_backlog_issues.py --project "Exo Holdout"  # Create issues
"""

import re
import subprocess
import json
import argparse
import sys
from pathlib import Path


class BacklogParser:
    """Parse the backlog.md file and extract tasks"""
    
    def __init__(self, backlog_path):
        self.backlog_path = Path(backlog_path)
        self.tasks = []
        self.current_category = None
        self.category_estimate = None
        
    def parse(self):
        """Parse the backlog file and extract all tasks"""
        with open(self.backlog_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        in_todo_section = False
        current_task = None
        
        for line in lines:
            # Check if we're in the "To Do" section
            if line.strip() == '### 📝 To Do':
                in_todo_section = True
                continue
            
            # Stop at next major section (but not #### which are categories)
            if in_todo_section and line.startswith('##') and not line.startswith('####'):
                break
            
            if not in_todo_section:
                continue
            
            # Check for category headers
            category_match = re.match(r'####\s+\*\*(.+?)\*\*\s+\(Est:\s+(.+?)\)', line)
            if category_match:
                self.current_category = category_match.group(1)
                self.category_estimate = category_match.group(2)
                continue
            
            # Check for task items (checkboxes)
            task_match = re.match(r'- \[ \]\s+\*\*(.+?)\*\*\s+\((\d+)\s+hrs?\)', line)
            if task_match:
                # Save previous task if exists
                if current_task:
                    self.tasks.append(current_task)
                
                # Start new task
                task_title = task_match.group(1)
                task_hours = task_match.group(2)
                current_task = {
                    'title': task_title,
                    'hours': task_hours,
                    'category': self.current_category,
                    'category_estimate': self.category_estimate,
                    'subtasks': []
                }
                continue
            
            # Check for subtask items (indented with bullets)
            if current_task and line.strip().startswith('-'):
                subtask = line.strip()[1:].strip()
                if subtask:
                    current_task['subtasks'].append(subtask)
        
        # Add the last task
        if current_task:
            self.tasks.append(current_task)
        
        return self.tasks
    
    def get_label_for_category(self, category):
        """Convert category to a GitHub label"""
        # Remove emoji and clean up
        label = re.sub(r'[^\w\s-]', '', category).strip()
        label = label.lower().replace(' ', '-')
        return label


class IssueCreator:
    """Create GitHub issues using the gh CLI"""
    
    def __init__(self, repo, dry_run=False, project=None):
        self.repo = repo
        self.dry_run = dry_run
        self.project = project
        
    def create_issue(self, task):
        """Create a single GitHub issue from a task"""
        title = task['title']
        
        # Build issue body
        body_parts = []
        body_parts.append(f"**Category:** {task['category']}")
        body_parts.append(f"**Estimated Time:** {task['hours']} hours")
        body_parts.append(f"**Category Total Estimate:** {task['category_estimate']}")
        body_parts.append("")
        
        if task['subtasks']:
            body_parts.append("## Tasks")
            body_parts.append("")
            for subtask in task['subtasks']:
                body_parts.append(f"- [ ] {subtask}")
            body_parts.append("")
        
        body_parts.append("---")
        body_parts.append("*This issue was automatically generated from docs/backlog.md*")
        
        body = "\n".join(body_parts)
        
        # Get label from category
        label = self.get_label_from_category(task['category'])
        
        if self.dry_run:
            print(f"\n{'='*80}")
            print(f"TITLE: {title}")
            print(f"LABEL: {label}")
            print(f"{'='*80}")
            print(body)
            return None
        else:
            # Create issue using gh CLI
            cmd = [
                'gh', 'issue', 'create',
                '--repo', self.repo,
                '--title', title,
                '--body', body,
                '--label', label
            ]
            
            try:
                result = subprocess.run(
                    cmd,
                    capture_output=True,
                    text=True,
                    check=True
                )
                issue_url = result.stdout.strip()
                print(f"✓ Created issue: {title}")
                print(f"  URL: {issue_url}")
                
                # Extract issue number from URL
                issue_number = issue_url.split('/')[-1]
                
                # Add to project if specified
                if self.project:
                    self.add_to_project(issue_number)
                
                return issue_url
            except subprocess.CalledProcessError as e:
                print(f"✗ Failed to create issue: {title}")
                print(f"  Error: {e.stderr}")
                return None
    
    def add_to_project(self, issue_number):
        """Add issue to GitHub Project"""
        try:
            # Use gh project item-add command
            cmd = [
                'gh', 'project', 'item-add', self.project,
                '--owner', self.repo.split('/')[0],
                '--url', f"https://github.com/{self.repo}/issues/{issue_number}"
            ]
            
            subprocess.run(cmd, capture_output=True, text=True, check=True)
            print(f"  ✓ Added to project: {self.project}")
        except subprocess.CalledProcessError as e:
            print(f"  ✗ Failed to add to project: {e.stderr}")
    
    def get_label_from_category(self, category):
        """Convert category to a GitHub label"""
        # Remove emoji and clean up
        label = re.sub(r'[^\w\s-]', '', category).strip()
        label = label.lower().replace(' ', '-')
        return label
    
    def ensure_labels_exist(self, tasks):
        """Ensure all required labels exist in the repository"""
        labels_needed = set()
        for task in tasks:
            label = self.get_label_from_category(task['category'])
            labels_needed.add(label)
        
        print(f"\nEnsuring labels exist: {', '.join(labels_needed)}")
        
        for label in labels_needed:
            if not self.dry_run:
                try:
                    # Try to create the label (will fail if it already exists, which is fine)
                    cmd = [
                        'gh', 'label', 'create', label,
                        '--repo', self.repo,
                        '--color', 'D4C5F9',  # Light purple
                        '--force'  # Update if exists
                    ]
                    subprocess.run(cmd, capture_output=True, text=True)
                except subprocess.CalledProcessError:
                    pass  # Label might already exist


def main():
    parser = argparse.ArgumentParser(
        description='Create GitHub issues from docs/backlog.md'
    )
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Preview issues without creating them'
    )
    parser.add_argument(
        '--project',
        type=str,
        help='GitHub Project name to add issues to (e.g., "Exo Holdout")'
    )
    parser.add_argument(
        '--repo',
        type=str,
        default='obscurelyme/exo-holdout',
        help='GitHub repository (default: obscurelyme/exo-holdout)'
    )
    parser.add_argument(
        '--backlog',
        type=str,
        default='docs/backlog.md',
        help='Path to backlog file (default: docs/backlog.md)'
    )
    
    args = parser.parse_args()
    
    # Get the repository root
    script_dir = Path(__file__).parent
    repo_root = script_dir.parent
    backlog_path = repo_root / args.backlog
    
    if not backlog_path.exists():
        print(f"Error: Backlog file not found: {backlog_path}")
        sys.exit(1)
    
    # Parse the backlog
    print(f"Parsing backlog from: {backlog_path}")
    parser_obj = BacklogParser(backlog_path)
    tasks = parser_obj.parse()
    
    print(f"Found {len(tasks)} tasks")
    
    if args.dry_run:
        print("\n*** DRY RUN MODE - No issues will be created ***\n")
    
    # Create issues
    creator = IssueCreator(args.repo, dry_run=args.dry_run, project=args.project)
    
    # Ensure labels exist
    creator.ensure_labels_exist(tasks)
    
    # Create each issue
    print(f"\nCreating issues...")
    created_count = 0
    for task in tasks:
        result = creator.create_issue(task)
        if result is not None or args.dry_run:
            created_count += 1
    
    print(f"\n{'='*80}")
    if args.dry_run:
        print(f"Previewed {created_count} issues")
        print("\nTo create these issues, run without --dry-run:")
        cmd = f"python scripts/create_backlog_issues.py"
        if args.project:
            cmd += f' --project "{args.project}"'
        print(f"  {cmd}")
    else:
        print(f"Successfully created {created_count} issues")
    print(f"{'='*80}")


if __name__ == '__main__':
    main()
