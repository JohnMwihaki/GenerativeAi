# Codebase Genius  

### *An Agentic Code Documentation System (Jac 0.8 + Python Helpers)*

---

##  Overview

**Codebase Genius** is an AI-powered, multi-agent system built in **Jac Language (v0.8)** that automatically generates clear, structured **Markdown documentation** for any public GitHub repository.  

Given a repository URL, the system:
1. Clones the repo locally.  
2. Maps its file structure and summarizes the README.  
3. Analyzes Python and Jac source code to build a **Code Context Graph (CCG)**.  
4. Synthesizes human-readable documentation including project overview, module summaries, and class/function relationships.

The project demonstrates the power of **Jac’s agentic architecture**, combining autonomous **walkers** with **Python helper modules** for code parsing and filesystem operations.

---

## System Architecture

Codebase Genius follows a modular, multi-agent architecture inspired by **Jaseci Labs' byLLM Task Manager**.

### Main Agents

| Agent | Description |
|--------|--------------|
| **Supervisor (Code Genius)** | Orchestrates the full workflow. Accepts a GitHub URL, triggers subordinate agents, aggregates outputs, and assembles final documentation. |
| **Repo Mapper** | Clones the repository, builds a file tree, filters unnecessary directories (e.g., `.git`, `node_modules`), and summarizes the README. |
| **Code Analyzer** | Uses `Tree-sitter` and AST parsing to analyze functions, classes, and imports, building the **Code Context Graph (CCG)** showing relationships. |
| **DocGenie** | Synthesizes results from other agents into a coherent Markdown document with diagrams and structured sections (Overview, Installation, Usage, API Reference). |

---

##  Folder Structure

```
agent_codebase_genius/
|-Server
├── main.jac # Entry point (accepts repo URL, spawns Supervisor)
├── agents/
│ ├── repo_mapper.jac # Repository cloning and file mapping
│ ├── code_analyzer.jac # Code analysis and graph generation
│ ├── docgenie.jac # Documentation synthesis
| |── supervisor.jac # Main orchestrator walker
├
│ └── utils/
│ ├── git_tools.py # Git operations (clone, generate docs)
│ ├── parser_tools.py # Source code parsing and graph building
│ ├── requirements.txt # Python helper dependencies
├── outputs/ # Generated results
│ ├── <repo_name>/
│ │ ├── repo/ # Cloned repository
│ │ ├── file_tree.json
│ │ ├── ccg.json
│ │ └── docs.md # Final documentation output
└── README.md
```

---

## ⚙️ Prerequisites

- **Python 3.10+**
- **Git** installed on your system
- **Jac 0.8.x** (tested on `jaclang==0.8.10`)

---

##  Setup Instructions

### Create a Virtual Environment and Install Dependencies
```bash
cd agent_codebase_genius/Server
python3 -m venv .venv
source .venv/bin/activate  # (on Windows use `.venv\Scripts\activate`)
pip install -r utils/requirements.txt
```

# Running the Pipeline

```
jac run main.jac
```
## Clone Repository & Generate File Tree

```
python3 Server/utils/git_tools.py --clone --url https://github.com/<owner>/<repo>
```

# Analyze Source Code (Build CCG)

```
python3 Server/utils/parser_tools.py --analyze --path outputs/<repo_name>/repo
```


