walker repo_mapper {
    has url: str;
    has repo_path: str;
    has repo_name: str;
    has file_tree: dict;

    can init {
        std.out("Cloning and mapping repository: " + url);

        repo_path = std.py.call("./utils/git_tools.py", "clone_repo", url);

        file_tree = std.py.call("./utils/git_tools.py", "build_file_tree", repo_path);

        repo_name = std.split(url, "/")[-1].replace(".git", "");

        std.out("Repository '" + repo_name + "' mapped successfully!");
        std.report("repo_path", repo_path);
        std.report("file_tree", file_tree);
    }
}
