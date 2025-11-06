import "supervisor.jac";

walker main_module {
    has url: str;

    can init {
        std.out("Starting Codebase Genius...");
        std.out("Enter repository URL or local path:");

       
        url = std.input();

        spawn supervisor with url;
    }
}
