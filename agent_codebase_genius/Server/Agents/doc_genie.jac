import "std";
py_import("json");
py_import("os");
py_import("utils.diagram_tools");

walker docgenie {
    has repo_path: str;

    can init {
        std.out("DocGenie started...");

        repo_parts = repo_path.split("/");
        repo_name = repo_parts[len(repo_parts) - 2] if len(repo_parts) >= 2 else repo_parts[0];
        std.out("Generating documentation for: " + repo_name);

        ccg_path = "./outputs/" + repo_name + "/ccg.json";
        readme_path = "./outputs/" + repo_name + "/readme.md";
        doc_path = "./outputs/" + repo_name + "/docs.md";

        markdown_doc = "# Project Documentation for `" + repo_name + "`\n\n";

        
        if std.fs.exists(readme_path) {
            std.out("Adding README summary...");
            readme_content = std.fs.read(readme_path);
            lines = readme_content.split("\n");
            summary = "\n".join(lines[:30]);
            markdown_doc += "##  Project Overview\n\n" + summary + "\n\n---\n\n";
        }

       
        if std.fs.exists(ccg_path) {
            std.out(" Adding code structure overview...");
            ccg_json = py_call("json.load", [std.fs.open(ccg_path)]);
            markdown_doc += "##  Code Structure Summary\n\n";
            for file in ccg_json["files"].keys() {
                markdown_doc += "###  `" + file + "`\n";
                info = ccg_json["files"][file];
                if len(info["classes"]) > 0 {
                    markdown_doc += "**Classes:** " + ", ".join(info["classes"]) + "\n\n";
                }
                if len(info["functions"]) > 0 {
                    markdown_doc += "**Functions:** " + ", ".join(info["functions"]) + "\n\n";
            }
        } else {
            std.out("No CCG found; skipping code structure section.");
        }

       
        std.fs.write(doc_path, markdown_doc);
        std.out("Markdown documentation saved to: " + doc_path);

        
        if std.fs.exists(ccg_path) {
            std.out(" Generating visual diagram...");
            py_call("utils.diagram_tools.generate_diagram", [
                ccg_path,
                "./outputs/" + repo_name + "/diagram.png"
            ]);
            std.out(" Diagram generated successfully!");
            markdown_doc += "\n\n![Code Diagram](diagram.png)\n";
            std.fs.write(doc_path, markdown_doc);  
        } else {
            std.out(" No CCG file found; skipping diagram generation.");
        }

        std.out(" DocGenie completed successfully for: " + repo_name);
    }
}
