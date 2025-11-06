import <repo_mapper.jac>;
import <code_analyzer.jac>;
import <docgenie.jac>;

walker supervisor {
    has url: str;

    can init {
        std.out("Starting supervisor for repo: " + url);

        spawn repo_mapper with url;
        take;
        repo_path = payload.repo_path;
        file_tree = payload.file_tree;

        spawn code_analyzer with repo_path;
        take;
        analysis_report = payload.analysis_report;
        spawn docgenie with repo_name=std.split(url, "/")[-1], repo_summary="", analysis_report=analysis_report;

        std.out("Full documentation pipeline complete!");
    }
}
walker api_docgen {
    has url: str;

    can entrypoint generate_docs {
        """
        HTTP endpoint: POST /generate_docs
        Body: {"url": "<GitHub repo URL>"}
        """

        if url == None or len(url) == 0 {
            std.out("No URL provided in API request.");
            return {"status": "error", "message": "Repository URL is required."};
        }

        std.out("🌐 API request received for repo: " + url);

        # Run the same pipeline as the CLI
        spawn repo_mapper with url;
        spawn code_analyzer;
        spawn docgenie;

        return {
            "status": "success",
            "message": "Documentation generated successfully.",
            "repo_url": url,
            "output_path": "./outputs/"
        };
    }
}
