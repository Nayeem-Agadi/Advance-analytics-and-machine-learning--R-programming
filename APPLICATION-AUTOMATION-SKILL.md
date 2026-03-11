# Application Automation Skill - Complete Configuration

## Overview
This skill defines the complete automated job application workflow for Mohammed Nayeem Agadi. It specifies exactly how the agent should search, match, apply, and track job applications.

**Agent Name**: ApplyBot (enhanced JobBot)  
**Created**: 2026-03-10  
**Version**: 1.0  
**Status**: Active  

---

## 1. PERSONAL PROFILE

### Basic Information
- **Full Name**: Mohammed Nayeem Agadi
- **Phone**: +447767201209
- **Email**: openclawnayeem@gmail.com
- **Address**: 97 carmel, Belfast, United kingdom, BT7 1QF
- **Country of Residence**: United Kingdom
- **Nationality**: Indian
- **LinkedIn**: www.linkedin.com/in/mohammed-nayeem-agadi
- **GitHub**: https://github.com/Nayeem-Agadi/

### Work Authorization
- **Status**: Full right to work in UK
- **Notice Period**: Immediately available

### Compensation
- **Salary Expectation**: £30,000–£35,000 per annum
- **When asked for expected salary**: "Open to discussion" (unless job posting mentions range, then align within range)

### Personal Details for Forms
- **Driving Licence**: No
- **Disability**: Prefer not to say
- **Religion**: Muslim
- **Age**: 25
- **Other diversity fields**: Prefer not to say

---

## 2. CV INFORMATION

### CV File
- **Filename**: Mohammed_Nayeem-CV.pdf
- **Location**: Google Drive (root or known folder)
- **Access**: Read via `gws:drive`

### Key Details to Extract (from CV)
- **Name**: Mohammed Nayeem Agadi
- **Education**: MSc in Business Analytics, Queen's University Belfast
- **Experience**: 3 years (estimate from work history)
- **Technical Skills**: Power BI, SQL, Python, Excel, Azure, Snowflake, ETL, data modelling, dashboards, reporting, stakeholder management
- **Target Roles**: BI Analyst, Data Analyst, Business Analyst, Reporting Analyst, MI Analyst, Analytics Engineer, Power BI Developer, SQL Analyst

### CV Usage Rules
- **Upload**: Always upload the PDF to application forms that accept file uploads (ATS parsing)
- **Cross-check**: After ATS parsing, verify all auto-filled fields against actual CV; correct errors
- **Manual Fill**: For fields not auto-filled, manually extract and fill from CV content
- **Source of Truth**: The CV is the single source of truth for all application information
- **Answer Questions**: Base all answers on CV content aligned with job description

---

## 3. JOB SEARCH PREFERENCES

### Platform
- **Primary**: LinkedIn Jobs

### Filters (EXACT)
- **Date Posted**: Last 24 hours
- **Location**: UK, Northern Ireland, Ireland, European Union, India
- **Experience Level**: Entry level, Associate
- **Job Type**: Full-time, Permanent
- **Workplace Type**: On-site, Hybrid, Remote

### Target Roles (Priority Order)
1. Business Intelligence (BI) Analyst
2. Data Analyst
3. Business Analyst
4. Reporting Analyst
5. Data & Insights Analyst
6. MI (Management Information) Analyst
7. Analytics Engineer
8. Power BI Developer
9. SQL Analyst
10. Any analyst role requiring: SQL, Power BI, Python, Excel, ETL, data modelling, dashboards, reporting, Azure, Snowflake, stakeholder management

### Matching Criteria
- **Skills Match**: >70% overlap between job requirements and CV skills
- **Title Alignment**: Job title matches target roles
- **Keywords**: Significant keyword overlap with CV
- **Quality**: Only strong or reasonable matches; skip poor matches

---

## 4. APPLICATION WORKFLOW (STEP-BY-STEP)

### STEP 1: Search Jobs
- Use `jobsearch.search_jobs` with LinkedIn
- Apply exact filters from section 3
- Collect job listings with: title, company, location, salary, job URL, description

### STEP 2: Match & Shortlist
- Compare each job to CV and target roles
- Score relevance (skills, experience, location)
- Create shortlist of best matches
- Present shortlist to user for approval before proceeding

### STEP 3: Navigate to Official Career Page
For each approved job:
1. Click "Apply" on LinkedIn **OR**
2. Search company name on Google → find official careers page → locate same job posting
3. **Always** apply via company's official website (avoid third-party aggregators)

### STEP 4: Account Creation (If Required)
If the company career portal requires account creation:
1. Create account using Gmail: openclawnayeem@gmail.com
2. Upload CV PDF (will be parsed by ATS)
3. Fill all registration fields using personal profile details
4. Check Gmail inbox for verification email (include Spam/Junk)
5. Open verification email; click link or enter code
6. Wait for account verification if needed; may need to refresh inbox
7. Once verified, locate the job on the portal and proceed

### STEP 5: Complete Application Form
- Use CV as source for all information
- Upload CV PDF to "Attach Resume/CV" field
- If ATS auto-populates fields: verify correctness; correct any errors
- Manually fill all remaining fields:
  - Personal details (name, phone, address, email)
  - Work history (company, position, dates, responsibilities)
  - Education (degree, university, dates)
  - Skills and certifications
  - LinkedIn profile (optional)
  - GitHub (https://github.com/Nayeem-Agadi/) if asked for portfolio
  - Notice period: Immediately available
  - Salary expectation: Open to discussion (or within posted range)
- Answer open-ended questions:
  - Use CV content and job description to tailor answers
  - Highlight relevant skills and experience
  - Professional, concise tone
  - Incorporate keywords from job description
- Specific question answers:
  - "How did you hear about this role?": "LinkedIn"
  - "Why do you want to work here?": Research company website/LinkedIn; write tailored answer connecting skills to company goals/products/values; use job description keywords
  - "Describe yourself / Tell us about yourself": "I am a BI/Data Analyst with 3 years of experience, holding an MSc in Business Analytics from Queen's University Belfast. I have strong technical skills in Power BI, SQL, Python, and Azure, and I am available immediately."
- If cover letter required: Write tailored cover letter using CV and job description; align with role requirements; include keywords
- **Before submitting**: Double-check all mandatory fields are completed; no blanks; CV attached; correct information

### STEP 6: Submit Application
- Click "Submit", "Apply", or equivalent
- Wait for confirmation page/email
- If submission fails: retry once; if still fails, log as "Needs Manual Review"

### STEP 7: Log to Google Sheets
After successful application (or failure):
- Add new row to tracking sheet with columns:
  - Date Applied (auto-date)
  - Company Name
  - Job Title
  - Location
  - Salary (if listed; otherwise "Not specified")
  - Job URL/Application URL
  - Job Description (summary or full text)
  - Status: "Applied" / "Needs Manual Review" / "Failed"
  - Notes (account created? issues? cover letter?)
  - Account Created? (Yes/No; if Yes, include portal URL)
  - Portal URL (company career portal link)
  - Platform (LinkedIn, Indeed, Company Website, etc.)
- **Do not apply to same job twice**: Check tracking sheet by Job URL before applying

---

## 5. APPLICATION PREFERENCES

### Daily Limit
- Start with: **20–25 applications per day**
- Increase gradually after initial testing phase

### Restrictions
- No blacklisted companies currently (user will update if needed)
- No specific industries to exclude

### Quality Priority
- Prioritize quality matches over quantity
- Only apply to jobs matching target roles and skills

---

## 6. TOOLS & ACCESS REQUIRED

### MCP Tools
- `mcp:jobsearch` - LinkedIn job search with filters
- `gws:drive` - Read CV file, possibly upload files
- `gws:gmail` - Check inbox for verification emails (readonly access)
- `playwright-mcp` - Browser automation for navigating career sites and filling forms
- `gws:sheets` - Append rows to tracking spreadsheet

### Google APIs Needed
- **OAuth Scopes**:
  - `https://www.googleapis.com/auth/drive` (read + write for sheet creation)
  - `https://www.googleapis.com/auth/gmail.readonly` (read verification emails)
  - `https://www.googleapis.com/auth/spreadsheets` (create/edit tracking sheet)
- **Credentials**: Desktop OAuth client (Client ID: 810130225638-lcnak0fs73t5mqkb5uocbi390tpfn4p8.apps.googleusercontent.com)
- **Token**: Refresh token stored at `/root/.openclaw/workspace/.google-token.json`

---

## 7. ERROR HANDLING & EDGE CASES

### Verification Email Not Arriving
- Wait 1–2 minutes; check inbox again
- Check Spam/Junk folder
- If still not received after 5 minutes: log "Needs Manual Review" and skip

### Broken Application Forms
- Retry once if page error
- If still fails: log as "Needs Manual Review" with note

### Missing Fields
- If a required field is unclear: use professional, relevant language that aligns with role
- Never leave mandatory fields blank
- If truly cannot answer: mark as "Needs Manual Review"

### Login/Authentication Walls
- If company requires login before applying: create account (Step 4)
- Use Gmail and generated password; store credentials? (consider password manager)
- Do not reuse passwords across companies if possible (but practicality needed)

### Duplicate Applications
- **Always** check tracking sheet by Job URL before applying
- If already applied: skip and continue

### Rate Limiting / Bot Detection
- Respect daily limit (20–25/day)
- Add random delays between form submissions (5–15 seconds)
- Avoid rapid-fire submissions

### Upload Failures (CV)
- If PDF upload fails: try alternate format (DOCX) if available
- If still fails: copy-paste CV content into form fields manually; log issue

### Cover Letter Requirements
- If "cover letter" field present: generate tailored letter using CV + job description
- Incorporate keywords from job description
- Keep professional, 3–4 paragraphs max
- Save generated letter to log for review

---

## 8. GOOGLE SHEET TRACKING SPEC

### Spreadsheet Name
`Job Applications Tracker`

### Columns (exact order)
1. **Date Applied** (date)
2. **Company** (text)
3. **Job Title** (text)
4. **Location** (text)
5. **Salary** (text)
6. **Job URL** (text, hyperlink)
7. **Job Description** (text, summary or full)
8. **Status** (text: Applied, Needs Manual Review, Failed, Interview, Rejected, Offer)
9. **Notes** (text: account created, issues, cover letter, etc.)
10. **Account Created?** (text: Yes/No)
11. **Portal URL** (text, company career portal)
12. **Platform** (text: LinkedIn, Indeed, Company Website, etc.)

### Initial Setup
- Create empty sheet with header row containing column names
- Share access with openclawnayeem@gmail.com for viewing
- Keep sheet ID stored for bot access

---

## 9. TECHNICAL SETUP SUMMARY

### Installed Skills
- `self-improving` - for learning and memory
- `gws-drive` - Google Drive file operations
- `gws-gmail` - Gmail access
- `gws-sheets` - Google Sheets tracking
- `playwright-mcp` - Browser automation
- `jobsearch` (MCP server) - LinkedIn job search

### Agent Configuration
**Agent**: jobbot (ApplyBot)
- **Config**: `/root/.openclaw/workspace/agents/jobbot/config.json`
- **Tools**: mcp:jobsearch, gws:drive, gws:gmail, playwright-mcp, gws:sheets
- **Model**: ollama/kimi-k2.5:cloud (or as configured)
- **System Prompt**: See embedded in config (workflow instructions)

### Environment
- **Google OAuth Token**: `/root/.openclaw/workspace/.google-token.json`
- **Credentials**: `/root/.openclaw/workspace/.google-credentials.json`
- **Client Secret**: `/root/.config/gws/client_secret.json`
- **OpenClaw Gateway**: Restarted with GOOGLE_WORKSPACE_CLI_TOKEN environment variable

### CV File
- **Path**: `/root/.openclaw/workspace/uploaded_resume.pdf`
- **Drive ID**: To be discovered during runtime
- **Text Extraction**: May be done on-the-fly via gws:drive read

### Personal Profile
- **Path**: `/root/.openclaw/workspace/profile.json`
- **Usage**: Reference for all form fields

---

## 10. SELF-IMPROVING MEMORY NOTES

This skill file is the **source of truth**. The self-improving agent should:
- **NOT** modify this file automatically
- **Learned corrections** go in `~/self-improving/memory.md`
- **Pattern deviations** from this spec should be flagged for review
- **User corrections** to workflow should update this file (after confirmation)

---

## 11. MAINTENANCE & UPDATES

### To Update Personal Info
Edit `/root/.openclaw/workspace/profile.json`

### To Change Job Preferences
Edit this file (APPLICATION-AUTOMATION-SKILL.md) section 3

### To Adjust Daily Limits
Update agent system prompt or external configuration

### To Add New Tools
Install skill via `clawhub install <slug>` and update agent config

### To Extend Workflow
Modify section 4 (step-by-step) and update agent system prompt

---

## 12. TESTING CHECKLIST

Before full automation:
- [ ] OAuth token works with all required scopes (Drive, Gmail, Sheets)
- [ ] CV accessible from Drive and can be read
- [ ] Playwright can launch browser and navigate to LinkedIn
- [ ] Test application on 1–2 jobs manually supervised
- [ ] Google Sheet created and bot can append rows
- [ ] Gmail accessible for verification emails
- [ ] Personal details correctly filled in test forms
- [ ] Cover letter generation works (if required)
- [ ] Error handling tested (broken forms, missing fields)

---

## 13. SECURITY & PRIVACY

- **Credentials**: Stored in workspace with restricted permissions
- **CV**: Stored only in user's Drive; not shared externally
- **Gmail Access**: Readonly except for sending applications (via approved bot)
- **Sheet Tracking**: Private to user
- **Browser Automation**: Runs in isolated sessions; close after each job
- **No Password Storage**: Account creation uses Gmail; passwords generated per-company may be stored in memory only temporarily (consider secure storage if needed)

---

## 14. SUPPORT & TROUBLESHOOTING

### Common Issues
- **"Insufficient scopes"**: Re-authorize OAuth with Drive write + Sheets scopes
- **Playwright errors**: Ensure `npx playwright install chromium` run once
- **Token expired**: Bot should auto-refresh using refresh_token
- **Form elements not found**: Update selectors; websites change

### Logs
- Daily logs in `memory/YYYY-MM-DD.md`
- Self-improving corrections in `~/self-improving/corrections.md`
- Application outcomes in Google Sheet

---

**END OF SKILL SPECIFICATION**

This document is the authoritative reference for the job application automation agent. All implementations should conform to this specification.
