package it.ecsc2024.jeopardy.chall.services;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;


public final class AddSecretIngredientService extends AbsRecipeService {

    @Override
    protected Bundle doWork(Context context, @NonNull Bundle data) {
        storage.addIngredient(data.getInt("id"), "ECSC{th3_s3cr4t_1ngr3d1en7_1s_n0t_p1n34ppl3_:))}");
        return null;
    }
}
