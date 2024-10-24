package it.ecsc2024.jeopardy.chall.services;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import it.ecsc2024.jeopardy.chall.RecipeStorage;


public final class ListRecipesService extends AbsRecipeService {
    @Override
    protected Bundle doWork(Context context, @NonNull Bundle data) {
        RecipeStorage.Recipe[] recipes = storage.list();

        Bundle respData = new Bundle();
        respData.putString("recipes", new Gson().toJson(recipes));
        return respData;
    }
}
