package com.jarvanmo.wechatplugin.utils;

import android.content.res.AssetFileDescriptor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.jarvanmo.wechatplugin.constant.WeChatPluginImageSchema;
import com.jarvanmo.wechatplugin.constant.WechatPluginKeys;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import io.flutter.plugin.common.PluginRegistry;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import okio.Okio;
import okio.Source;

public class WeChatThumbnailUtil {
    private static final int COMMON_THUMB_SIZE = 150;

    private WeChatThumbnailUtil() {
    }

    public static byte[] thumbnailForMiniProgram(String thumbnail, PluginRegistry.Registrar registrar) {
        byte[] result = null;
        if (thumbnail.startsWith(WeChatPluginImageSchema.SCHEMA_ASSETS)) {
            result = fromAssetForMiniProgram(thumbnail, registrar);
        } else if (thumbnail.startsWith(WeChatPluginImageSchema.SCHEMA_FILE)) {

        } else {

        }
        return result;
    }


    private static byte[] fromAssetForMiniProgram(String thumbnail, PluginRegistry.Registrar registrar) {
        byte[] result = null;
        String key = thumbnail.substring(WeChatPluginImageSchema.SCHEMA_ASSETS.length(), thumbnail.length());
        AssetFileDescriptor fileDescriptor = AssetManagerUtil.openAsset(registrar, key, getPackage(key));

        if (fileDescriptor != null && fileDescriptor.getLength() <= 128 * 1024) {
            try {
                Source source = Okio.source(fileDescriptor.createInputStream());
                result = Okio.buffer(source).readByteArray();
                source.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else if (fileDescriptor != null && fileDescriptor.getLength() > 128 * 1024) {
            File file = FileUtil.createTmpFile(fileDescriptor);
            if (file == null) {
                return null;
            }
            File snapshot = CompressImageUtil.compressUtilSmallerThan(128, file, registrar.context());
            if (snapshot == null) {
                return null;
            }

            try {
                result = Okio.buffer(Okio.source(snapshot)).readByteArray();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

        return result;
    }

    public static byte[] thumbnailForCommon(String thumbnail, PluginRegistry.Registrar registrar) {
        byte[] result = null;
        if (thumbnail.startsWith(WeChatPluginImageSchema.SCHEMA_ASSETS)) {
            result = fromAssetForCommon(thumbnail, registrar);
        } else if (thumbnail.startsWith(WeChatPluginImageSchema.SCHEMA_FILE)) {
            Bitmap bmp = BitmapFactory.decodeFile(thumbnail);
            Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, COMMON_THUMB_SIZE, COMMON_THUMB_SIZE, true);
            bmp.recycle();
            result = Util.bmpToByteArray(thumbBmp, true);
        } else {
            InputStream input = openStream(thumbnail);
            if (input != null) {
                Bitmap bmp = BitmapFactory.decodeStream(input);
                Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, COMMON_THUMB_SIZE, COMMON_THUMB_SIZE, true);
                bmp.recycle();
                result = Util.bmpToByteArray(thumbBmp, true);
            }
        }
        return result;
    }

    private static byte[] fromAssetForCommon(String thumbnail, PluginRegistry.Registrar registrar) {
        int size = 32;
        byte[] result = null;
        String key = thumbnail.substring(WeChatPluginImageSchema.SCHEMA_ASSETS.length(), thumbnail.length());
        AssetFileDescriptor fileDescriptor = AssetManagerUtil.openAsset(registrar, key, getPackage(key));

        if (fileDescriptor != null && fileDescriptor.getLength() <= size * 1024) {
            try {
                Source source = Okio.source(fileDescriptor.createInputStream());
                result = Okio.buffer(source).readByteArray();
                source.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else if (fileDescriptor != null && fileDescriptor.getLength() > size * 1024) {
            File file = FileUtil.createTmpFile(fileDescriptor);
            if (file == null) {
                return null;
            }
            File snapshot = CompressImageUtil.compressUtilSmallerThan(size, file, registrar.context());
            if (snapshot == null) {
                return null;
            }

            try {
                result = Okio.buffer(Okio.source(snapshot)).readByteArray();
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

//        Bitmap bmp = BitmapFactory.decodeStream(new URL(url).openStream());
//        Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, COMMON_THUMB_SIZE, COMMON_THUMB_SIZE, true);
//        bmp.recycle();
//       result = Util.bmpToByteArray(thumbBmp, true);
        return result;
    }

    private static String getPackage(String assetsName) {
        String packageStr = null;
        if (assetsName.contains(WechatPluginKeys.PACKAGE)) {
            int index = assetsName.indexOf(WechatPluginKeys.PACKAGE);
            packageStr = assetsName.substring(index + WechatPluginKeys.PACKAGE.length(), assetsName.length());
        }
        return packageStr;
    }

    private static InputStream openStream(String url){
        OkHttpClient okHttpClient = new OkHttpClient.Builder().build();
        Request request = new Request.Builder().url(url).get().build();
        try {
         Response response = okHttpClient.newCall(request).execute();
            ResponseBody responseBody = response.body();
         if(response.isSuccessful() &&  responseBody!= null){
             return responseBody.byteStream();
         }else {
             return null;
         }

        } catch (IOException e) {
            e.printStackTrace();
            return  null;
        }

    }
}
