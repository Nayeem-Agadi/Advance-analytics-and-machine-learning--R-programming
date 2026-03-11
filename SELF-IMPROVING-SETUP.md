# Self-Improving Agent Setup Complete

## Overview

The self-improving agent skill is now installed and configured. This system enables the agent to:
- Learn from corrections and mistakes
- Remember preferences and patterns
- Automatically improve performance over time
- Apply learned patterns to future tasks

## Memory Structure

```
~/self-improving/
├── memory.md          # HOT: Active patterns (≤100 lines, always loaded)
├── corrections.md     # Log of corrections and lessons
├── index.md          # Index of all memory files
├── domains/          # Domain-specific patterns (code, writing, etc.)
├── projects/         # Project-specific overrides
└── archive/          # COLD: Archived patterns (>90 days unused)
```

## How It Works

1. **Before non-trivial tasks**: Agent reads `memory.md` and relevant domain/project files
2. **During interactions**: Agent logs corrections, preferences, and successful patterns
3. **Automatic promotion**: Patterns used 3+ times in 7 days → promoted to HOT
4. **Automatic demotion**: Unused patterns → archived after 90 days

## Integration Points

- **AGENTS.md**: Updated with self-improving memory location and routing rules
- **SOUL.md**: Added self-improving steering to maintain quality focus
- **Memory separation**:
  - `memory/YYYY-MM-DD.md` & `MEMORY.md` for factual context (events, decisions)
  - `~/self-improving/` for execution quality improvements (patterns, preferences, corrections)

## Quick Commands

To check memory stats:
```
ls -la ~/self-improving/
cat ~/self-improving/memory.md
cat ~/self-improving/corrections.md
```

To manually review patterns, ask the agent: "What have you learned?" or "Memory stats"

## Next Steps

The self-improving system is now active. It will:
- Automatically log corrections when you provide feedback
- Load relevant patterns before tasks
- Suggest improvements based on past experiences

You can test it by:
1. Starting a conversation
2. Correcting the agent if it makes a mistake
3. Observing it reference past patterns in future responses

The system starts in **Passive** mode (only learns from explicit corrections). You can change the mode by editing `~/self-improving/memory.md` if desired.
