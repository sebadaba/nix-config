---
name: read-documents
description: Use when you need to read a file (PDF, DOCX, PPTX, XLSX, HTML, image, etc.). Always delegate to markdown-summarizer subagent — get summary first, then decide if full read is necessary.
---
# Reading documents
When you need to extract information from a file:
## Workflow
1. **Delegate** to `markdown-summarizer` via Task tool. Tell it what file and what you need.
2. **Read the summary.** Decide:
   - Found what you need? Done.
   - Need more detail on a section? Ask the subagent to drill into that specific section.
3. **Never** call markitdown or similar tools directly (they're disabled for you).
4. **Never** ask for *full* raw/unsummarized markdown.
