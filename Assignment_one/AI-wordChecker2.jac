import from byllm.llm { Model }

glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);


def hintMessage(word: str, length: int) -> str by llm();

walker WordCheckerAI {
    has word: str;

    can start with `root entry;
    can processWord with turn entry;
}

node turn {
    has word_length: int;
}


with entry:__main__ {
    root spawn WordCheckerAI("Jac");
    root spawn WordCheckerAI("john mwihaki");
    root spawn WordCheckerAI("profgramminggenerativewithjac");
}
