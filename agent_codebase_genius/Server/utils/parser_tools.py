import argparse
import os
import json
from pathlib import Path
import re

try:
    from tree_sitter import Language, Parser
    TREE_SITTER_AVAILABLE = True
except Exception:
    TREE_SITTER_AVAILABLE = False

def extract_py_symbols_simple(file_path):
    funcs = []
    classes = []
    try:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            for line in f:
                fn = re.match(r'^\s*def\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(', line)
                if fn:
                    funcs.append(fn.group(1))
                cl = re.match(r'^\s*class\s+([A-Za-z_][A-Za-z0-9_]*)\s*[:\(]', line)
                if cl:
                    classes.append(cl.group(1))
    except Exception as e:
        print(f"[parser_tools] Error reading {file_path}: {e}")
    return funcs, classes

def build_ccg(root_path):
    ccg = {"files": {}}
    root_path = Path(root_path)
    for dirpath, dirnames, filenames in os.walk(root_path):
        for fname in filenames:
            if fname.endswith(".py"):
                fp = Path(dirpath) / fname
                rel = str(fp.relative_to(root_path))
                funcs, classes = extract_py_symbols_simple(str(fp))
                ccg["files"][rel] = {
                    "functions": funcs,
                    "classes": classes
                }
    return ccg

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--analyze", action="store_true")
    ap.add_argument("--path", type=str, default="")
    args = ap.parse_args()
    if args.analyze:
        if not args.path:
            print("Provide --path")
            return
        repo_root = args.path
        repo_name = Path(repo_root).parent.name
        ccg = build_ccg(repo_root)
        out = Path(f"outputs/{repo_name}/ccg.json")
        out.parent.mkdir(parents=True, exist_ok=True)
        with open(out, "w", encoding="utf-8") as f:
            json.dump(ccg, f, indent=2)
        print(f"[parser_tools] Wrote CCG to {out}")
    else:
        print("No action. Use --analyze --path <repo>")

if __name__ == "__main__":
    main()
