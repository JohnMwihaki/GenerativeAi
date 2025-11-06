from __future__ import annotations
import os
from pathlib import Path
from typing import Tuple

def repo_name_from_url(url: str) -> str:
    name = url.rstrip("/").split("/")[-1].replace(".git", "")
    return name or "repo"

def outputs_dir_for_repo(repo_root: str) -> str:
    p = Path(repo_root)
    if p.name == "repo":
        repo_root_dir = p.parent
    else:
        repo_root_dir = p
    out = repo_root_dir.parent / repo_root_dir.name
    out_path = path_str = str(out)
    Path(path_str).mkdir(parents=True, exist_ok=True)
    return path_str

def save_markdown(md_text: str, repo_root: str, filename: str = "docs.md") -> str:
    out_dir = Path(repo_root).parent / "outputs" / Path(repo_root).parent.name
    p = Path(repo_root)
    if p.name == "repo":
        out_dir = p.parent / "outputs" / p.parent.name
    else:
        out_dir = p / "outputs"
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / filename
    out_path.write_text(md_text, encoding="utf-8")
    return str(out_path)
