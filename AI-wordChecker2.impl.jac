impl WordCheckerAI.start {
    if not [root --> (`?turn)] {
        next = root ++> turn(len(self.word));
    } else {
        next = [root --> (`?turn)];
    }
    visit next;
}

impl WordCheckerAI.processWord {
    if [-->] {
        visit [-->];
    } else {
        print(f"The word '{self.word}' has {here.word_length} letters.");
        print(hintMessage(self.word, here.word_length));
        disengage;
    }
}
