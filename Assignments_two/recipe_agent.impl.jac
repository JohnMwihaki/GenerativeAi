impl RecipeAgent.start {
    if not [root --> (`?kitchen)] {
        next = root ++> kitchen(self.ingredients);
    } else {
        next = [root --> (`?kitchen)];
    }
    visit next;
}

impl RecipeAgent.recommend {
    print("Available ingredients: " + here.stored_ingredients);
    suggestion = suggest_recipe(here.stored_ingredients);
    print("Suggested recipe: " + suggestion);
    disengage;
}
