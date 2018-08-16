package com.jarvan.fluwx.utils;

import android.content.res.AssetFileDescriptor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;


import com.jarvan.fluwx.constant.WeChatPluginImageSchema;
import com.jarvan.fluwx.constant.WechatPluginKeys;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.util.UUID;

import io.flutter.plugin.common.PluginRegistry;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import okio.BufferedSink;
import okio.Okio;
import okio.Source;
import top.zibin.luban.Luban;

public class WeChatThumbnailUtil {
    public static final int SHARE_IMAGE_THUMB_LENGTH = 32;
    private static final int COMMON_THUMB_WIDTH = 150;

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
        File file;
        if (thumbnail.startsWith(WeChatPluginImageSchema.SCHEMA_ASSETS)) {
            file = fromAssetForCommon(thumbnail, registrar);
        } else if (thumbnail.startsWith(WeChatPluginImageSchema.SCHEMA_FILE)) {
            file = new File(thumbnail);
        } else {
            file = downloadImage(thumbnail);
        }
        return compress(file, registrar);
    }

    private static byte[] compress(File file, PluginRegistry.Registrar registrar) {
        if (file == null) {
            return new byte[]{};
        }

        int size = SHARE_IMAGE_THUMB_LENGTH * 1024;

        try {
            File file1 = Luban
                    .with(registrar.context())
                    .setTargetDir(registrar.context().getCacheDir().getAbsolutePath())
                    .ignoreBy(32)
                    .get(file.getAbsolutePath());
            if(file.length() <= 32 * 1024){
                return Util.bmpToByteArray(BitmapFactory.decodeFile(file1.getAbsolutePath()), true);
            }else {
                return continueCompress(file1);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        return  new byte[]{};
    }

    private static byte[] continueCompress(File file){
        //        Bitmap bitmap = ThumbnailCompressUtil.makeNormalBitmap(file.getAbsolutePath(), -1, 32 * 1024);
//        if (bitmap.getByteCount() <= size) {
//            return bmpToByteArray(bitmap,true);
//        }
//
//
//        byte[] result = Util.bmpToByteArray(bitmap, true);
//        if (result.length <= size) {
//            return result;
//        }
//
        Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());

        Bitmap bitmap2 = ThumbnailCompressUtil.createScaledBitmapWithRatio(bitmap, COMMON_THUMB_WIDTH, false);

        Util.getHtmlByteArray()
        if(bitmap2.getByteCount() <= 32 * 1024){
            return bmpToByteArray(bitmap2,true);
        }

        bitmap = ThumbnailCompressUtil.createScaledBitmap(bitmap,COMMON_THUMB_WIDTH,true);

        return bmpToByteArray(bitmap,true);
    }

    private static byte[] bmpToByteArray(Bitmap bitmap, boolean recycle) {
        int bytes = bitmap.getByteCount();
        ByteBuffer buf = ByteBuffer.allocate(bytes);
        bitmap.copyPixelsToBuffer(buf);
        if (recycle) {
            bitmap.recycle();
        }

        return buf.array();
    }

    private static File fromAssetForCommon(String thumbnail, PluginRegistry.Registrar registrar) {
        File result = null;
        String key = thumbnail.substring(WeChatPluginImageSchema.SCHEMA_ASSETS.length(), thumbnail.length());
        AssetFileDescriptor fileDescriptor = AssetManagerUtil.openAsset(registrar, key, getPackage(key));

        if (fileDescriptor != null) {
            try {
                result = File.createTempFile(UUID.randomUUID().toString(), getSuffix(key));
                OutputStream outputStream = new FileOutputStream(result);
                BufferedSink sink = Okio.buffer(Okio.sink(outputStream));
                Source source = Okio.source(fileDescriptor.createInputStream());
                sink.writeAll(source);
                sink.flush();

                source.close();
                sink.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
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

    private static File downloadImage(String url) {
        File result = null;
        OkHttpClient okHttpClient = new OkHttpClient.Builder().build();
        Request request = new Request.Builder().url(url).get().build();
        try {
            Response response = okHttpClient.newCall(request).execute();
            ResponseBody responseBody = response.body();
            if (response.isSuccessful() && responseBody != null) {
                result = File.createTempFile(UUID.randomUUID().toString(), getSuffix(url));
                OutputStream outputStream = new FileOutputStream(result);
                BufferedSink sink = Okio.buffer(Okio.sink(outputStream));
                Source source = Okio.source(responseBody.byteStream());
                sink.writeAll(source);
                sink.flush();

                source.close();
                sink.close();
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        return result;
    }

    private static String getSuffix(String path) {
        String suffix = ".jpg";
        int index = path.lastIndexOf(".");
        if (index > 0) {
            suffix = path.substring(index, path.length());
        }
        return suffix;
    }
}
