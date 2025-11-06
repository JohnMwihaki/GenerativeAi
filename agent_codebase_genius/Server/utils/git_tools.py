import argparse
import os
import shutil
import json
import subprocess
from pathlib import Path

try:
    from git import Repo
    GITPYTHON_AVAILABLE = True
except ImportError:
    GITPYTHON_AVAILABLE = False

def clone_repo(url: str, dest_root: str = "outputs") -> str:
    repo_name = url.rstrip("/").split("/")[-1].replace(".git", "")
    out_dir = Path(dest_root) / repo_name / "repo"
    if out_dir.exists():
        print(f"[git_tools] Removing existing {out_dir}")
        shutil.rmtree(out_dir)
    out_dir.parent.mkdir(parents=True, exist_ok=True)
    print(f"[git_tools] Cloning {url} into {out_dir}")
    if GITPYTHON_AVAILABLE:
        Repo.clone_from(url, str(out_dir))
    else:
        subprocess.check_call(["git", "clone", url, str(out_dir)])
    return str(out_dir)

def build_file_tree(root_path: str, ignore_dirs=None) -> dict:
    if ignore_dirs is None:
        ignore_dirs = {".git", "__pycache__", "node_modules", "venv", ".venv"}
    tree = {}
    root_path = Path(root_path)
    for dirpath, _, filenames in os.walk(root_path):
        rel = os.path.relpath(dirpath, root_path)
        parts = rel.split(os.sep) if rel != "." else []
        if any(p in ignore_dirs for p in parts):
            continue
        key = "." if rel == "." else rel
        tree.setdefault(key, []).extend(sorted(filenames))
    return tree

def read_readme(root_path: str) -> str:
    candidates = ["README.md", "README.MD", "readme.md", "Readme.md"]
    for c in candidates:
        p = Path(root_path) / c
        if p.exists():
            try:
                return p.read_text(encoding="utf-8")
            except Exception:
                return p.read_text(encoding="latin-1", errors="ignore")
    return ""

def write_json(data, outpath: str):
    Path(outpath).parent.mkdir(parents=True, exist_ok=True)
    with open(outpath, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

def generate_markdown_summary(repo_root: str, out_md: str):
    tree = build_file_tree(repo_root)
    readme = read_readme(repo_root)
    lines = []
    repo_name = Path(repo_root).parent.name
    lines.append(f"# Project documentation for `{repo_name}`\n")
    if readme:
        lines.append("## README (first 40 lines)\n")
        lines.extend(readme.splitlines()[:40])
        lines.append("\n---\n")
    lines.append("## File tree (summary)\n")
    for k in sorted(tree.keys()):
        lines.append(f"**{k}**")
        for f in sorted(tree[k]):
            lines.append(f"- {f}")
    Path(out_md).parent.mkdir(parents=True, exist_ok=True)
    with open(out_md, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"[git_tools] Wrote docs to {out_md}")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--clone", action="store_true")
    ap.add_argument("--map", action="store_true")
    ap.add_argument("--generate-docs", action="store_true")
    ap.add_argument("--url", type=str, default="")
    ap.add_argument("--path", type=str, default="")
    args = ap.parse_args()
    if args.clone:
        if not args.url:
            print("Provide --url")
            return
        repo_path = clone_repo(args.url)
        repo_name = Path(repo_path).parent.name
        write_json(build_file_tree(repo_path), f"outputs/{repo_name}/file_tree.json")
        readme_txt = read_readme(repo_path)
        if readme_txt:
            with open(f"outputs/{repo_name}/readme.md", "w", encoding="utf-8") as f:
                f.write(readme_txt)
        print(f"[git_tools] clone+map complete. Outputs in outputs/{repo_name}/")
    elif args.map:
        if not args.path:
            print("Provide --path")
            return
        repo_root = args.path
        repo_name = Path(repo_root).parent.name
        write_json(build_file_tree(repo_root), f"outputs/{repo_name}/file_tree.json")
        print(f"[git_tools] map complete -> outputs/{repo_name}/file_tree.json")
    elif args.generate_docs:
        if not args.path:
            print("Provide --path")
            return
        repo_root = args.path
        repo_name = Path(repo_root).parent.name
        out_md = f"outputs/{repo_name}/docs.md"
        generate_markdown_summary(repo_root, out_md)
    else:
        ap.print_help()

if __name__ == "__main__":
    main()
