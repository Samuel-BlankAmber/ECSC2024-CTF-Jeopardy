package it.ecsc2024.jeopardy.chall.services;

import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Process;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import it.ecsc2024.jeopardy.chall.RecipeStorage;

public abstract class AbsRecipeService extends Service {
    protected RecipeStorage storage;
    private ServiceHandler serviceHandler;

    @Override
    public void onCreate() {
        HandlerThread thread = new HandlerThread(this.getClass().getSimpleName(), Process.THREAD_PRIORITY_BACKGROUND);
        thread.start();

        serviceHandler = new ServiceHandler(thread.getLooper());

        storage = new RecipeStorage(this);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Message msg = serviceHandler.obtainMessage();
        msg.arg1 = startId;
        msg.setData(intent.getExtras());
        serviceHandler.sendMessage(msg);
        return START_NOT_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Nullable
    protected abstract Bundle doWork(Context context, @NonNull Bundle data);

    private final class ServiceHandler extends Handler {
        public ServiceHandler(Looper looper) {
            super(looper);
        }

        @Override
        public void handleMessage(@NonNull Message req) {
            Log.d(AbsRecipeService.this.getClass().getSimpleName(), "Handle message");

            Bundle reqData = req.getData();
            Bundle respData = doWork(getApplicationContext(), reqData);
            if (respData == null) {
                respData = new Bundle();
            }

            PendingIntent respIntent = reqData.getParcelable("intent", PendingIntent.class);
            if (respIntent != null) {
                Intent intent = new Intent();
                intent.putExtras(respData);

                Log.d(AbsRecipeService.this.getClass().getSimpleName(), "Send message response");

                try {
                    respIntent.send(AbsRecipeService.this, 0, intent);
                } catch (PendingIntent.CanceledException e) {
                    // ignored
                }
            }

            stopSelf(req.arg1);
        }
    }
}
