package it.ecsc2024.jeopardy.chall.services;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;


public final class CreateRecipeService extends AbsRecipeService {

    @Override
    protected Bundle doWork(Context context, @NonNull Bundle data) {
        int id = storage.create(data.getString("name"), data.getString("description"));

        Bundle respData = new Bundle();
        respData.putInt("id", id);
        return respData;
    }
}
