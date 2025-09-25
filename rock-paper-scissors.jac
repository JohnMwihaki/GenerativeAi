"""Rock–Paper–Scissors Game on Scale Agnostic Example"""

import random;

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
    root spawn  rock_paper_scissors("scissors");
}
