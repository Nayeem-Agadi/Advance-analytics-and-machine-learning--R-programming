#!/bin/bash
# OpenClaw Environment Setup for OpenRouter
# Run: source /root/.openclaw/workspace/setup/env-setup.sh

# Set OpenRouter API Key (from user input)
export OPENROUTER_API_KEY="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"

# Optional: Add to bashrc for persistence
echo "export OPENROUTER_API_KEY=\$OPENROUTER_API_KEY" >> ~/.bashrc

echo "✅ OpenRouter API key configured!"
echo ""
echo "📋 Available Free Models:"
echo "  • google/gemini-2.0-flash-exp:free (default)"
echo "  • meta-llama/llama-3.3-70b-instruct:free"
echo "  • deepseek/deepseek-chat:free"
echo "  • qwen/qwen-2.5-72b-instruct:free"
echo ""
echo "🔧 To switch models:"
echo "  /model gemini-free"
echo "  /model llama-free"
echo "  /model deepseek-free"
echo "  /model qwen-free"
