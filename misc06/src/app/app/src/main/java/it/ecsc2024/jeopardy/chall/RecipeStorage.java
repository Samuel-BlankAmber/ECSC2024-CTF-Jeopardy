package it.ecsc2024.jeopardy.chall;

import android.content.Context;
import android.content.SharedPreferences;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.gson.Gson;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

public final class RecipeStorage {
    private final static Gson GSON = new Gson();
    private final Context context;
    private final SecureRandom rand = new SecureRandom();
    private final List<Recipe> recipes = new LinkedList<>();

    public RecipeStorage(Context context) {
        this.context = context;
    }

    private synchronized void load() {
        SharedPreferences sharedPrefs = context.getSharedPreferences("recipes", Context.MODE_PRIVATE);
        Recipe[] recipes = GSON.fromJson(sharedPrefs.getString("data", "[]"), Recipe[].class);
        this.recipes.clear();
        this.recipes.addAll(Arrays.asList(recipes));
    }

    private synchronized void save() {
        SharedPreferences sharedPrefs = context.getSharedPreferences("recipes", Context.MODE_PRIVATE);
        sharedPrefs.edit().putString("data", GSON.toJson(recipes.toArray(new Recipe[0]))).apply();
    }

    @NonNull
    public Recipe[] list() {
        load();
        return recipes.toArray(new Recipe[0]);
    }

    @Nullable
    public Recipe get(int id) {
        load();
        return recipes.stream().filter(recipe -> recipe.id == id).findFirst().orElse(null);
    }

    public int create(String name, String description) {
        load();
        Recipe recipe = new Recipe();
        recipe.id = rand.nextInt();
        recipe.name = name;
        recipe.description = description;
        recipe.ingredients = new ArrayList<>();
        recipes.add(recipe);
        save();

        return recipe.id;
    }

    public void addIngredient(int id, String ingredient) {
        Recipe recipe = get(id);
        if (recipe == null) {
            return;
        }

        recipe.ingredients.add(ingredient);
        save();
    }

    public void delete(int id) {
        load();
        recipes.removeIf(recipe -> recipe.id == id);
        save();
    }

    public static final class Recipe {
        int id;
        String name;
        String description;
        List<String> ingredients;
    }
}
