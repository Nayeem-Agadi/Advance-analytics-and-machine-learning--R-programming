# OpenClaw Job Application Automation - Complete Setup Guide

## Table of Contents
1. [Self-Improving Agent](#self-improving-agent)
2. [Google Workspace Setup](#google-workspace-setup)
3. [Application Automation Configuration](#application-automation-configuration)
4. [Testing & Activation](#testing--activation)

---

## Self-Improving Agent

### What It Does
The self-improving skill enhances your agent by:
- Capturing errors, corrections, and learnings from every session
- Storing learnings as `.learnings/` Markdown files in your workspace
- Injecting those learnings into context on each new task
- Enabling the agent to get smarter over time, retry bad outputs, and write revised skills when patterns repeat

### How It Works
The skill hooks into `UserPromptSubmit` and `PostToolUse` events:
1. Task comes in → existing `.learnings/` are injected into context
2. Agent executes → result is evaluated for quality
3. If poor result → agent self-critiques and retries
4. After success/failure → learning is logged to `.learnings/YYYY-MM-DD.md`
5. On next task → that learning shapes agent approach

### Installation Methods

#### Method 1: ClawHub CLI (Easiest)
```bash
npm install -g clawhub
clawhub install self-improving
```
Skills are picked up automatically on the next session — no restart needed.

#### Method 2: Direct Chat Install
Send your OpenClaw agent this message:
> "Install this skill and enable it in all future tasks: https://clawhub.ai/pskoett/self-improving"

The agent will fetch, install, and activate it itself.

#### Method 3: Manual Install
1. Go to https://clawhub.ai/pskoett/self-improving
2. Copy the raw `SKILL.md` content
3. Save to `<your-workspace>/skills/self-improving/SKILL.md`
4. OpenClaw loads workspace skills from `<workspace>/skills` and they take effect on the next session.

### Optional: Auto-Skill-Hunter
Install for proactive capability expansion:
```bash
clawhub install auto-skill-hunter
```
This companion skill discovers, ranks, and installs high-value ClawHub skills by mining unresolved user needs.

### Security Note
Before installing any skill, review potential security risks and validate the source. OpenClaw has a VirusTotal partnership that scans skills — check the skill's ClawHub page for a VirusTotal report before installing.

### Our Current Setup
- ✅ Skill installed: `self-improving` (version 1.2.10)
- ✅ Location: `/root/.openclaw/workspace/skills/self-improving/`
- ✅ Memory structure created at `~/self-improving/`
- ✅ Integrated into AGENTS.md and SOUL.md
- ✅ Agent reads learnings before non-trivial tasks

---

## Google Workspace Setup

### OAuth Client
- **Type**: Desktop App
- **Client ID**: `810130225638-lcnak0fs73t5mqkb5uocbi390tpfn4p8.apps.googleusercontent.com`
- **Project**: `810130225638`
- **Test User**: `openclawnayeem@gmail.com` (added to OAuth consent screen)

### Scopes Obtained
- ✅ `https://www.googleapis.com/auth/drive.readonly` (read Drive files)
- ✅ `https://www.googleapis.com/auth/gmail.readonly` (read Gmail)
- ⚠️ **Need to add**: `https://www.googleapis.com/auth/spreadsheets` (create/edit Sheets)
- ⚠️ **Need to add**: `https://www.googleapis.com/auth/drive` (write access for sheet creation)

### Token Information
- **Access Token**: Valid (1 hour)
- **Refresh Token**: Valid (7 days)
- **Saved to**: `/root/.openclaw/workspace/.google-token.json`
- **Environment**: `GOOGLE_WORKSPACE_CLI_TOKEN` set in OpenClaw gateway

### APIs Enabled
- ✅ Google Drive API
- ✅ Gmail API
- ⚠️ **Google Sheets API** (needs to be enabled if not already)

### Skills Installed
- `gws-drive` - Google Drive operations
- `gws-gmail` - Gmail operations
- `gws-sheets` - Google Sheets operations

---

## Application Automation Configuration

### Personal Profile
**Location**: `/root/.openclaw/workspace/profile.json`

```json
{
  "full_name": "Mohammed Nayeem Agadi",
  "phone": "+447767201209",
  "email": "openclawnayeem@gmail.com",
  "address": "97 carmel, Belfast, United kingdom, BT7 1QF",
  "country": "United Kingdom",
  "work_authorization": "full right to work in UK",
  "nationality": "Indian",
  "linkedin": "www.linkedin.com/in/mohammed-nayeem-agadi",
  "github": "https://github.com/Nayeem-Agadi/",
  "salary_expectation": "£30,000–£35,000 per annum"
}
```

### CV File
- **Filename**: `Mohammed_Nayeem-CV.pdf`
- **Location**: Google Drive (root folder)
- **Drive ID**: `1TNS6ZLLswJk1FaEPyBEzRHzBgKM7t0B1` (discovered during setup)
- **Usage**: Upload to application forms; cross-check ATS auto-filled fields; extract info for manual fills

### Job Search Preferences
- **Platform**: LinkedIn Jobs
- **Filters**:
  - Date posted: Last 24 hours
  - Location: UK, Northern Ireland, Ireland, EU, India
  - Experience: Entry level, Associate
  - Job type: Full-time, Permanent
  - Workplace: On-site, Hybrid, Remote
- **Target Roles**: BI Analyst, Data Analyst, Business Analyst, Reporting Analyst, MI Analyst, Analytics Engineer, Power BI Developer, SQL Analyst, and any analyst role with SQL/Power BI/Python/Excel/ETL/data modelling/dashboards/reporting/Azure/Snowflake/stakeholder management
- **Matching**: Skills match >70%, title alignment, keyword overlap; skip poor matches

### Application Workflow (Detailed)
See `APPLICATION-AUTOMATION-SKILL.md` for complete step-by-step:

1. **Search** LinkedIn with exact filters
2. **Match** jobs to CV using skills/keyword analysis
3. **Navigate** to company career page (official website only)
4. **Account Creation** (if required):
   - Use Gmail: openclawnayeem@gmail.com
   - Upload CV PDF
   - Fill registration fields from personal profile
   - Check Gmail for verification email (inbox + spam)
   - Click verification link or enter code
   - Wait for verification if needed
5. **Complete Application Form**:
   - Upload CV PDF (source: Drive)
   - Verify ATS auto-filled fields; correct errors
   - Manually fill all remaining fields using CV + job description
   - Answer open-ended questions professionally, incorporating job description keywords
   - Write tailored cover letter if required
   - Specific answers:
     - "How did you hear?": LinkedIn
     - "Why work here?": Research company; connect skills to goals/products/values
     - "Describe yourself": "BI/Data Analyst with 3 years experience, MSc in Business Analytics from Queen's University Belfast, strong skills in Power BI, SQL, Python, Azure, available immediately"
     - Expected salary: "Open to discussion" (or within posted range)
   - Double-check all mandatory fields before submitting
6. **Submit** application; verify confirmation
7. **Log** to Google Sheets with all required columns:
   - Date Applied | Company | Job Title | Location | Salary | Job URL | Job Description | Status | Notes | Account Created? | Portal URL | Platform

### Daily Limits & Rules
- **Maximum**: 20–25 applications per day (increase gradually)
- **No blacklisted companies** currently
- **Quality over quantity**: Only apply to strong matches
- **Never duplicate**: Check tracking sheet by Job URL before applying

### Tracking Spreadsheet
- **Name**: "Job Applications Tracker"
- **Columns** (exact order):
  1. Date Applied
  2. Company
  3. Job Title
  4. Location
  5. Salary
  6. Job URL
  7. Job Description
  8. Status (Applied, Needs Manual Review, Failed, Interview, Rejected, Offer)
  9. Notes
  10. Account Created?
  11. Portal URL
  12. Platform

### Tools Required
- `mcp:jobsearch` - LinkedIn job search
- `gws:drive` - Read CV
- `gws:gmail` - Read verification emails
- `playwright-mcp` - Browser automation for forms
- `gws:sheets` - Tracking sheet updates

---

## Testing & Activation

### Pre-Flight Checklist
- [ ] OAuth token has extended scopes (Drive write, Sheets, Gmail readonly)
- [ ] Google Sheets API enabled in project
- [ ] CV accessible in Drive and can be read
- [ ] Playwright installed: `npx playwright install chromium`
- [ ] Tracking spreadsheet created and bot has edit access
- [ ] Personal profile saved to `profile.json`
- [ ] Application automation skill read by agent

### Re-Authorization Needed
**Action Required**: Obtain new OAuth token with additional scopes.

I will generate a new authorization link with:
- `https://www.googleapis.com/auth/drive` (full Drive access)
- `https://www.googleapis.com/auth/spreadsheets` (Sheets full access)
- `https://www.googleapis.com/auth/gmail.readonly` (keep)

**Once you click and authorize**, we will:
1. Refresh token with new scopes
2. Create the Google Sheets tracking file
3. Test the workflow on 1–2 jobs (supervised)
4. Begin full automation (20–25/day)

---

## File Reference

| File | Purpose |
|------|---------|
| `APPLICATION-AUTOMATION-SKILL.md` | Complete workflow specification |
| `profile.json` | Personal details for forms |
| `uploaded_resume.pdf` | CV file |
| `/.google-credentials.json` | OAuth client credentials |
| `/.google-token.json` | OAuth access/refresh tokens |
| `~/.config/gws/client_secret.json` | gws CLI client config |
| `~/self-improving/` | Self-improving memory |
| `/agents/jobbot/config.json` | Agent configuration with tools & prompt |

---

## Next Step: Re-Authorize

**Please confirm**: Should I generate the re-authorization link with extended scopes now?

Once you approve, I'll provide a link. You'll:
1. Open it in browser
2. Sign in with openclawnayeem@gmail.com
3. Click "Allow" (will show additional permissions)
4. Copy the code and paste back here
5. Done (30 seconds)

Then we activate full automation.
