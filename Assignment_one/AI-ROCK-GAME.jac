"""Rock–Paper–Scissors Game AI Enhanced"""

import random;
import from byllm.llm { Model }


glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

def give_hint(player: str, computer: str, result: str) -> str by llm();


walker rock_paper_scissors {
    has playerChoice: str;

    can start with `root entry;
    can play_round with turn entry;
}


node turn {
    has computerChoice: str = random.choice(["rock", "paper", "scissors"]);
}


with entry:__main__ {
    root spawn rock_paper_scissors("rock");
    root spawn rock_paper_scissors("paper");
    root spawn rock_paper_scissors("scissors");
}
