import json
from graphviz import Digraph
import os

def generate_diagram(ccg_path, output_path):
    with open(ccg_path, "r", encoding="utf-8") as f:
        ccg = json.load(f)

    dot = Digraph(comment="Code Structure")
    dot.attr(rankdir="LR", size="8,5")

    for file, info in ccg.get("files", {}).items():
        file_node = f'file_{file}'
        dot.node(file_node, file, shape="folder")
        for cls in info.get("classes", []):
            cls_node = f'class_{file}_{cls}'
            dot.node(cls_node, cls, shape="box")
            dot.edge(file_node, cls_node)
        for func in info.get("functions", []):
            func_node = f'func_{file}_{func}'
            dot.node(func_node, func, shape="ellipse")
            dot.edge(file_node, func_node)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    dot.render(filename=output_path, format="png", cleanup=True)
