package it.ecsc2024.jeopardy.chall;

import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import it.ecsc2024.jeopardy.chall.services.AddIngredientService;
import it.ecsc2024.jeopardy.chall.services.AddSecretIngredientService;
import it.ecsc2024.jeopardy.chall.services.CreateRecipeService;
import it.ecsc2024.jeopardy.chall.services.DeleteRecipeService;
import it.ecsc2024.jeopardy.chall.services.ListRecipesService;

public final class RecipeService extends Service {
    public static final int MSG_CREATE_RECIPE = 1;
    public static final int MSG_DELETE_RECIPE = 2;
    public static final int MSG_LIST_RECIPES = 3;
    public static final int MSG_ADD_INGREDIENT = 4;
    public static final int MSG_ADD_SECRET_INGREDIENT = 5;
    private static final String TAG = "RecipeService";

    private static String sha256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encoded = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            return Base64.encodeToString(encoded, Base64.DEFAULT);
        } catch (NoSuchAlgorithmException e) {
            return null;
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        Messenger messenger = new Messenger(new IncomingHandler(this));
        return messenger.getBinder();
    }

    static class IncomingHandler extends Handler {
        private final Context applicationContext;

        IncomingHandler(@NonNull Context context) {
            super(Looper.getMainLooper());
            applicationContext = context.getApplicationContext();
        }

        @Override
        public void handleMessage(Message msg) {
            Log.d(TAG, "Handle message " + msg.what + " " + msg.getData());

            Intent intent = new Intent();
            intent.putExtras(msg.getData());
            intent.setPackage(applicationContext.getPackageName());

            switch (msg.what) {
                case MSG_CREATE_RECIPE:
                    intent.setClass(applicationContext, CreateRecipeService.class);
                    break;
                case MSG_DELETE_RECIPE:
                    intent.setClass(applicationContext, DeleteRecipeService.class);
                    break;
                case MSG_LIST_RECIPES:
                    intent.setClass(applicationContext, ListRecipesService.class);
                    break;
                case MSG_ADD_INGREDIENT:
                    intent.setClass(applicationContext, AddIngredientService.class);
                    break;
                case MSG_ADD_SECRET_INGREDIENT:
                    if ("xbQtSjIRFIGono5PmrY30aaHe3FoAsttnB9CZXo9vqs=".equals(sha256(msg.getData().getString("secret", "")))) {
                        intent.setClass(applicationContext, AddSecretIngredientService.class);
                    }
                    break;
                default:
                    Log.w(TAG, "Unknown message type: " + msg.what);
                    return;
            }

            PendingIntent pendingIntent = PendingIntent.getService(
                    applicationContext,
                    0,
                    intent,
                    PendingIntent.FLAG_MUTABLE | PendingIntent.FLAG_UPDATE_CURRENT
            );

            Bundle bundle = new Bundle();
            bundle.setClassLoader(this.getClass().getClassLoader());
            bundle.putParcelable("intent", pendingIntent);

            Message resp = Message.obtain();
            resp.setData(bundle);

            try {
                msg.replyTo.send(resp);
            } catch (android.os.RemoteException e) {
                Log.w(TAG, "Exception sending response", e);
            }
        }
    }
}