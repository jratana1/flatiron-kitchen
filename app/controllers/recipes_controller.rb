class RecipesController < ApplicationController
    def new
        @recipe = Recipe.new
        @ingredients = Ingredient.all
    end

    def create
       
        @recipe = Recipe.new(recipe_params)
        if @recipe.save
            if params.key?("ingredient_ids")
                params[:ingredient_ids].each do |id|
                    RecipeIngredient.create(:recipe_id => @recipe.id, :ingredient_id => id)
                end
            end
            redirect_to recipe_path(@recipe)
        else
            render "new"
        end
    end

    def edit
        @recipe = Recipe.find_by_id(params[:id])
        @ingredients = Ingredient.all
    end

    def update
        @recipe = Recipe.find(params[:id])
        if @recipe.update(recipe_params)
            @recipe.recipe_ingredients.destroy_all
            if params.key?("ingredient_ids")
                params[:ingredient_ids].each do |id|
                    RecipeIngredient.create(:recipe_id => @recipe.id, :ingredient_id => id)
                end
            end
          redirect_to recipe_path(@recipe)
        else 
            render "edit"
        end
    end

    def show
        @recipe = Recipe.find_by_id(params[:id])
    end

    private
    def recipe_params
        params.require(:recipe).permit(:name)
    end
end
