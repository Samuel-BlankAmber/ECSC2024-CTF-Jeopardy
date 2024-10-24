package it.ecsc2024.jeopardy.chall.services;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;


public final class AddIngredientService extends AbsRecipeService {

    @Override
    protected Bundle doWork(Context context, @NonNull Bundle data) {
        storage.addIngredient(data.getInt("id"), data.getString("ingredient"));
        return null;
    }
}
