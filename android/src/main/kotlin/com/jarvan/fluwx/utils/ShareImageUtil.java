package com.jarvan.fluwx.utils;

import android.content.res.AssetFileDescriptor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.jarvan.fluwx.constant.WeChatPluginImageSchema;
import com.jarvan.fluwx.constant.WechatPluginKeys;


import java.io.IOException;
import java.io.InputStream;

import io.flutter.plugin.common.PluginRegistry;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;

public class ShareImageUtil {

    public static byte[] getImageData(PluginRegistry.Registrar registrar, String path) {
        byte[] result = null;
        if (path.startsWith(WeChatPluginImageSchema.SCHEMA_ASSETS)) {
            String key = path.substring(WeChatPluginImageSchema.SCHEMA_ASSETS.length(), path.length());
            AssetFileDescriptor fileDescriptor = AssetManagerUtil.openAsset(registrar, key, getPackage(key));
            try {
                InputStream inputStream = fileDescriptor.createInputStream();
                result = streamToByteArray(inputStream);
            } catch (IOException e) {
                e.printStackTrace();
            }

        } else if (path.startsWith(WeChatPluginImageSchema.SCHEMA_FILE)) {
            Bitmap bmp = null;
            bmp = BitmapFactory.decodeFile(path);
            result = Util.bmpToByteArray(bmp, true);
        } else {
            InputStream inputStream = openStream(path);
            if (inputStream != null) {
                result = streamToByteArray(inputStream);
            }
        }

        return result;
    }

    private static byte[] streamToByteArray(InputStream inputStream) {
        Bitmap bmp = null;
        bmp = BitmapFactory.decodeStream(inputStream);
        return Util.bmpToByteArray(bmp, true);
    }

    private static String getPackage(String assetsName) {
        String packageStr = null;
        if (assetsName.contains(WechatPluginKeys.PACKAGE)) {
            int index = assetsName.indexOf(WechatPluginKeys.PACKAGE);
            packageStr = assetsName.substring(index + WechatPluginKeys.PACKAGE.length(), assetsName.length());
        }
        return packageStr;
    }

    private static InputStream openStream(String url) {
        OkHttpClient okHttpClient = new OkHttpClient.Builder().build();
        Request request = new Request.Builder().url(url).get().build();
        try {
            Response response = okHttpClient.newCall(request).execute();
            ResponseBody responseBody = response.body();
            if (response.isSuccessful() && responseBody != null) {
                return responseBody.byteStream();
            } else {
                return null;
            }

        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

    }
}
