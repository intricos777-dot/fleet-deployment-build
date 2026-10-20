<!-- Watermark: Living_Sin (intricos777-dot) + AI agents (Hermes, Lia, opencode) - collaborative work -->
# Hermes & Opencode work prompts

Bring back to life the toolset I prompted for in prior builds so hermes and
opencode sessions stay usable after the MCP reload.

## Prompts

### hermes-session
Use when the user asks to review, re-run, or continue a Hermes agent session.
Retrieve the day's session text, request dumps, and open-items.

### opencode-session
Use when the user asks to review, re-run, or continue an Opencode session.
Pull the opencode.db session history, todos, and tool-output.

### fleet-status
Use when the user asks for the current fleet deployment status (IOWeight,
Zen ISO, [community] repo, solo miners, USB admission, BCH wallet, Dogecoin
address, Ravencoin route, polsia payouts, SSH key, anchor set, listener
baseline, repo visibility).

### session-index
Use when the user asks for an index of what sessions exist, what is open,
or what has been done today. Merges the Hermes session-log repo with
opencode.db and hermes process-results.

## Resources

### hermes-logs
The hermes agent log, proxy for agent state, and process-results.
Copy the live log and process-results into the workspace so they are
read-only refs (not source-of-truth).

### opencode-db
The opencode sqlite database with sessions, messages, todos, projects.
Read directly from ~/.local/share/opencode/opencode.db.

### session-log-repo
The session-log repo (sessions/, data/, work/open-items.md) - the
canonical per-day record of what was asked and what is unfinished.

### memory
The hermes memory files (MEMORY.md, USER.md).
