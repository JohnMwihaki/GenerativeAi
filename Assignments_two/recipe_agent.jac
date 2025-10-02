import from byllm.llm { Model }

glob llm = Model(model_name="gpt-4o-mini", verbose=False);

"""Ask the AI to suggest a recipe from ingredients"""
def suggest_recipe(ingredients:str) -> str by llm();

walker RecipeAgent {
    has ingredients: str;

    can start with `root entry;
    can recommend with kitchen entry;
}

node kitchen {
    has stored_ingredients: str;
}

with entry:__main__ {
    root spawn RecipeAgent("tomato, rice, chicken");
    root spawn RecipeAgent("eggs, cheese, bread");
}
