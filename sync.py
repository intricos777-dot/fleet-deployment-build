#!/usr/bin/env python3
"""Sync hermes + opencode session data into the torch store."""
import json, os, sqlite3, shutil, glob
from datetime import datetime

HOME = os.path.expanduser('~')
HERMES = os.path.join(HOME, '.hermes')
OPCODE = os.path.join(HOME, '.local', 'share', 'opencode')
SESSION_LOG = os.path.join(HOME, 'Projects', 'session-log')
VOID_WORKSPACE = '/home/livings/Projects/torch-workspace'

def read_sessions():
    """Read opencode sessions + hermes sessions into one index.""
    out = {'opencode': [], 'hermes': [], 'hermes_cli': [], 'session_log': []}
    # opencode sessions
    db = os.path.join(OPCODE, 'opencode.db')
    if os.path.exists(db):
        conn = sqlite3.connect(db)
        conn.row_factory = sqlite3.Row
        for r in conn.execute('SELECT id, title, model, time_created, tokens_input, tokens_output FROM session ORDER BY time_created DESC LIMIT 50'):
            out['opencode'].append({'id': r['id'], 'title': r['title'], 'model': r['model'], 'created': r['time_created'], 'input': r['tokens_input'], 'output': r['tokens_output']})
        conn.close()
    # hermes cli sessions
    hb = os.path.join(HOME, 'Projects', 'hermes-cli', 'sessions-backup', 'hermes-sessions.jsonl')
    if os.path.exists(hb):
        with open(hb) as f:
            for line in f:
                try:
                    out['hermes_cli'].append(json.loads(line))
                except Exception:
                    pass
    # session-log sessions
    for f in sorted(glob.glob(os.path.join(SESSION_LOG, 'sessions', '*.md'))):
        out['session_log'].append(os.path.basename(f))
    return out
