impl  rock_paper_scissors.start {
    if not [root --> (`?turn)] {
        next = root ++> turn(random.choice(["rock", "paper", "scissors"]));
    } else {
        next = [root --> (`?turn)];
    }
    visit next;
}

impl  rock_paper_scissors.play_round {
    if [-->] {
        visit [-->];
    } else {
        if self.playerChoice == here.computerChoice {
            print(f"Tie! Both chose {self.playerChoice}");
        } elif (self.playerChoice == "rock" and here.computerChoice == "scissors") or
             (self.playerChoice == "scissors" and here.computerChoice == "paper") or
             (self.playerChoice == "paper" and here.computerChoice == "rock") {
            print(f"You win! {self.playerChoice} beats {here.computerChoice}");
        } else {
            print(f"You lose! {here.computerChoice} beats {self.playerChoice}");
        }
        disengage;
    }
}
