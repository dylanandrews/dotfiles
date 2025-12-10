# GitHub Codespaces Setup Guide

This guide explains how to configure GitHub Codespaces secrets for automatic Claude Code MCP setup.

## Required GitHub Codespaces Secrets

To enable automatic MCP configuration in Codespaces, add your MCP secrets to your GitHub account.

### 1. Add Secrets to GitHub

Go to: https://github.com/settings/codespaces

Click "New secret" and add secrets for each MCP that requires authentication.

### 2. Update the Template

Edit `claude.json.template` in this repo to include your MCPs with environment variable placeholders:

```json
{
  "mcpServers": {
    "my-mcp": {
      "command": "npx",
      "args": ["my-mcp-package", "--token=${MY_MCP_TOKEN}"]
    }
  }
}
```

Use `${VARIABLE_NAME}` syntax for any secrets.

## How It Works

### Automatic Setup Flow

1. **Create a new Codespace** → GitHub clones your dotfiles repo
2. **GitHub runs `install.sh`** → Dotfiles installation begins
3. **Claude Code MCP config is created** → `install.sh` processes `claude.json.template`
4. **Environment variables are substituted** → GitHub Codespaces secrets are injected
5. **Ready to use** → Launch Claude Code with all MCPs configured

### File Structure

```
~/.dotfiles/
├── claude.json.template      # Template with ${ENV_VAR} placeholders
├── install.sh                # Installer that processes the template
└── CODESPACES_SETUP.md      # This file

After installation in Codespace:
~/.claude.json               # Final config with secrets injected
```

## Updating Existing Codespaces

If you created a Codespace before adding secrets or pushing dotfiles updates:

```bash
# Pull latest dotfiles
cd /workspaces/.codespaces/.persistedshare/dotfiles
git pull origin master

# Re-run installer
./install.sh

# Verify configuration
cat ~/.claude.json
# Should show your actual token values, not ${VARIABLE_NAME}
```

## Security Notes

✅ **Safe to commit:**
- `claude.json.template` with `${ENV_VAR}` placeholders
- `install.sh` script
- This documentation

❌ **Never commit:**
- Actual API tokens or passwords
- Generated `~/.claude.json` files with real secrets
- Any file containing hardcoded credentials

✅ **Secrets are stored:**
- In GitHub's encrypted secrets storage
- Injected as environment variables in Codespaces only
- Never visible in repository files

## Troubleshooting

### MCPs not working in Codespace

Check if secrets are available:
```bash
# Should show your token (not empty)
echo $YOUR_MCP_TOKEN
```

If empty, secrets weren't added to GitHub. Add them at https://github.com/settings/codespaces

### Environment variables not substituted

Check if `envsubst` is available:
```bash
command -v envsubst
```

If not found, install it:
```bash
sudo apt-get install gettext-base
```

Then re-run `./install.sh`

### Claude Code not seeing MCPs

Verify the config file exists and has real values:
```bash
cat ~/.claude.json
# Should NOT see ${YOUR_TOKEN}, should see actual token
```

If you see `${VARIABLE_NAME}`, the substitution didn't work. Re-run installer after adding secrets.

## Local Development

This MCP auto-configuration only runs in Codespaces. For local development:

1. Your MCPs should be configured in your local `~/.claude.json`
2. The template is only for Codespaces automation
3. You can maintain separate MCP configurations for local vs Codespaces

## Verifying Setup

After creating a new Codespace:

```bash
# 1. Check secrets are loaded
echo "Token: ${YOUR_TOKEN:0:10}..." # Shows first 10 chars

# 2. Check .claude.json exists
ls -la ~/.claude.json

# 3. Check tokens were substituted (not showing ${VAR_NAME})
grep -q '${' ~/.claude.json && echo "❌ Env vars not substituted" || echo "✅ Secrets injected"

# 4. Start Claude Code and check MCPs
claude
# Then type: /mcp
# Should see your configured MCPs
```

## Project-Specific MCPs

You can configure MCPs that only load for specific projects using the `projects` section:

```json
{
  "mcpServers": {
    "global-mcp": { ... }
  },
  "projects": {
    "/workspaces/your-project": {
      "mcpServers": {
        "project-specific-mcp": { ... }
      }
    }
  }
}
```

This is useful for MCPs that only make sense in certain codebases (like database connections).
