impl WordChecker.start {
    if not [root --> (`?turn)] {
        next = root ++> turn(len(self.word));
    } else {
        next = [root --> (`?turn)];
    }
    visit next;
}

impl WordChecker.process_word {
    if [-->] {
        visit [-->];
    } else {
        print("The word \"" + self.word + '\' has " + str(here.word_length) + " letters.");
        disengage;
    }
}
