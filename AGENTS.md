# Agent Instructions

This project uses **bd** (beads) for issue tracking. Run `bd onboard` to get started.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work atomically
bd close <id>         # Complete work
bd dolt push          # Push beads data to remote
```

## Non-Interactive Shell Commands

**ALWAYS use non-interactive flags** with file operations to avoid hanging on confirmation prompts.

Shell commands like `cp`, `mv`, and `rm` may be aliased to include `-i` (interactive) mode on some systems, causing the agent to hang indefinitely waiting for y/n input.

**Use these forms instead:**
```bash
# Force overwrite without prompting
cp -f source dest           # NOT: cp source dest
mv -f source dest           # NOT: mv source dest
rm -f file                  # NOT: rm file

# For recursive operations
rm -rf directory            # NOT: rm -r directory
cp -rf source dest          # NOT: cp -r source dest
```

**Other commands that may prompt:**
- `scp` - use `-o BatchMode=yes` for non-interactive
- `ssh` - use `-o BatchMode=yes` to fail instead of prompting
- `apt-get` - use `-y` flag
- `brew` - use `HOMEBREW_NO_AUTO_UPDATE=1` env var

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until **the PR is merged to main**.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **OPEN PR + MERGE** — `main` is protected; **direct push is blocked**. Required status check: `vendor-leak-check / check`. `enforce_admins: true` — no admin bypass. Workflow:
   ```bash
   git pull --rebase origin main
   bd dolt push                                       # beads sync stays direct (Dolt remote, not git)
   git push -u origin <feature-branch>                # push to feature branch, NOT main
   gh pr create --base main --head <feature-branch> \
     --title "<conventional commit subject>" --body "..."
   gh pr checks --watch                               # block until required checks complete
   gh pr merge <pr-number> --merge --delete-branch    # only proceeds if all required checks green
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - PR merged, branch deleted, beads pushed to Dolt
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until **the PR is merged to main**
- NEVER attempt direct push to main — it will be rejected by branch protection
- NEVER bypass the `vendor-leak-check` or any other required check — see CLAUDE.md "Branch Protection & Merge Workflow"
- NEVER say "ready to push when you are" — YOU must create the PR and merge it
- If checks fail, fix the underlying issue and push a new commit to the feature branch; do not request a bypass
<!-- END BEADS INTEGRATION -->
