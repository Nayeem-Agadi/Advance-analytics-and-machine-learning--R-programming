#!/usr/bin/env python3
"""
JobSpy MCP Server for OpenClaw
Searches jobs across LinkedIn, Indeed, Glassdoor, ZipRecruiter, Google Jobs, Bayt, Naukri, and BDJobs
"""

import json
import sys
from typing import Any, Dict, List, Optional
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent, ImageContent, EmbeddedResource
import jobspy
from jobspy import scrape_jobs

app = Server("jobspy-mcp-server")

SUPPORTED_SITES = ["linkedin", "indeed", "glassdoor", "zip_recruiter", "google", "bayt", "naukri", "bdjobs"]
SUPPORTED_JOB_TYPES = ["fulltime", "parttime", "internship", "contract"]

@app.list_tools()
async def list_tools() -> List[Tool]:
    return [
        Tool(
            name="scrape_jobs_tool",
            description="Search for jobs across multiple job boards with filtering options",
            inputSchema={
                "type": "object",
                "properties": {
                    "search_term": {
                        "type": "string",
                        "description": "Job keywords (e.g., 'software engineer', 'cloud support')"
                    },
                    "location": {
                        "type": "string",
                        "description": "Job location (e.g., 'London', 'Dubai', 'Remote')"
                    },
                    "site_name": {
                        "type": "array",
                        "items": {"type": "string", "enum": SUPPORTED_SITES},
                        "description": "Job boards to search",
                        "default": ["indeed", "linkedin"]
                    },
                    "results_wanted": {
                        "type": "integer",
                        "description": "Number of results (1-1000)",
                        "default": 15
                    },
                    "job_type": {
                        "type": "string",
                        "enum": SUPPORTED_JOB_TYPES,
                        "description": "Employment type"
                    },
                    "is_remote": {
                        "type": "boolean",
                        "description": "Filter for remote jobs only",
                        "default": False
                    },
                    "hours_old": {
                        "type": "integer",
                        "description": "Filter by posting recency in hours"
                    },
                    "distance": {
                        "type": "integer",
                        "description": "Search radius in miles (1-100)",
                        "default": 50
                    },
                    "easy_apply": {
                        "type": "boolean",
                        "description": "Filter for easy apply options",
                        "default": False
                    },
                    "country_indeed": {
                        "type": "string",
                        "description": "Country for Indeed/Glassdoor (e.g., 'united kingdom', 'ireland', 'uae')",
                        "default": "usa"
                    },
                    "linkedin_fetch_description": {
                        "type": "boolean",
                        "description": "Fetch full LinkedIn descriptions (slower, rate-limited)",
                        "default": False
                    },
                    "offset": {
                        "type": "integer",
                        "description": "Pagination offset",
                        "default": 0
                    }
                },
                "required": ["search_term"]
            }
        ),
        Tool(
            name="get_supported_countries",
            description="Get list of supported countries for job searches",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="get_supported_sites",
            description="Get information about all supported job board sites",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="get_job_search_tips",
            description="Get tips and best practices for job searching",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        )
    ]

@app.call_tool()
async def call_tool(name: str, arguments: Dict[str, Any]) -> List[TextContent]:
    if name == "scrape_jobs_tool":
        try:
            # Build search parameters
            search_params = {
                "site_name": arguments.get("site_name", ["indeed", "linkedin"]),
                "search_term": arguments["search_term"],
                "location": arguments.get("location"),
                "results_wanted": arguments.get("results_wanted", 15),
                "distance": arguments.get("distance", 50),
                "is_remote": arguments.get("is_remote", False),
                "easy_apply": arguments.get("easy_apply", False),
                "linkedin_fetch_description": arguments.get("linkedin_fetch_description", False),
                "offset": arguments.get("offset", 0)
            }
            
            # Add optional filters
            if arguments.get("job_type"):
                search_params["job_type"] = arguments["job_type"]
            if arguments.get("hours_old"):
                search_params["hours_old"] = arguments["hours_old"]
            if arguments.get("country_indeed"):
                search_params["country_indeed"] = arguments["country_indeed"]
            
            # Remove None values
            search_params = {k: v for k, v in search_params.items() if v is not None}
            
            # Execute search
            jobs = scrape_jobs(**search_params)
            
            # Convert to JSON-serializable format
            jobs_list = jobs.to_dict('records') if hasattr(jobs, 'to_dict') else []
            
            # Clean up the response
            for job in jobs_list:
                # Handle NaN values
                for key, value in job.items():
                    if str(value) == 'nan' or value != value:  # Check for NaN
                        job[key] = None
            
            return [TextContent(type="text", text=json.dumps({
                "success": True,
                "total_found": len(jobs_list),
                "jobs": jobs_list
            }, indent=2, default=str))]
            
        except Exception as e:
            return [TextContent(type="text", text=json.dumps({
                "success": False,
                "error": str(e),
                "message": f"Error searching jobs: {str(e)}"
            }, indent=2))]
    
    elif name == "get_supported_countries":
        countries = [
            "usa", "united kingdom", "ireland", "canada", "australia",
            "germany", "france", "netherlands", "singapore", "india",
            "uae", "saudi arabia", "qatar", "kuwait", "bahrain", "oman",
            "south africa", "japan", "south korea", "brazil", "mexico"
        ]
        return [TextContent(type="text", text=json.dumps({
            "countries": countries
        }, indent=2))]
    
    elif name == "get_supported_sites":
        sites_info = [
            {"name": "indeed", "description": "Largest job search engine, most reliable", "regions": "Global"},
            {"name": "linkedin", "description": "Professional networking platform, rate limited", "regions": "Global"},
            {"name": "glassdoor", "description": "Jobs with company reviews and salaries", "regions": "Global"},
            {"name": "zip_recruiter", "description": "Job matching for US/Canada", "regions": "US, Canada"},
            {"name": "google", "description": "Aggregated job listings", "regions": "Global"},
            {"name": "bayt", "description": "Middle East job portal", "regions": "GCC, Middle East"},
            {"name": "naukri", "description": "India's leading job portal", "regions": "India"},
            {"name": "bdjobs", "description": "Bangladesh job portal", "regions": "Bangladesh"}
        ]
        return [TextContent(type="text", text=json.dumps({
            "sites": sites_info
        }, indent=2))]
    
    elif name == "get_job_search_tips":
        tips = [
            "Start with specific job titles rather than broad terms",
            "Use Indeed for UK/Ireland - most reliable and less rate-limited",
            "Use Bayt for GCC countries (UAE, Saudi Arabia, Qatar, etc.)",
            "LinkedIn is rate-limited - use sparingly with smaller result sets",
            "Indeed limitations: only one filter group allowed (hours_old OR job_type/is_remote OR easy_apply)",
            "For visa sponsorship searches, include keywords like 'relocation', 'sponsorship', 'work permit'",
            "Search major tech hubs: London, Dublin, Dubai, Riyadh for more opportunities",
            "Set hours_old to 72 for recent postings without missing good opportunities"
        ]
        return [TextContent(type="text", text=json.dumps({
            "tips": tips
        }, indent=2))]
    
    else:
        return [TextContent(type="text", text=json.dumps({
            "error": f"Unknown tool: {name}"
        }, indent=2))]

async def main():
    async with stdio_server() as (read_stream, write_stream):
        await app.run(read_stream, write_stream, app.create_initialization_options())

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
