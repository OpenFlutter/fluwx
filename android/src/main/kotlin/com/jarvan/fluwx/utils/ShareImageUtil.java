package com.jarvan.fluwx.utils;

import android.content.res.AssetFileDescriptor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.jarvan.fluwx.constant.WeChatPluginImageSchema;
import com.jarvan.fluwx.constant.WechatPluginKeys;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
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
//            result = handleNetworkImage(registrar, path);
            result = Util.inputStreamToByte(openStream(path));
        }

        return result;
    }

    private static byte[] handleNetworkImage(PluginRegistry.Registrar registrar, String path) {
        byte[] result = null;
        InputStream inputStream = openStream(path);

        if (inputStream == null) {
            return null;
        }



        String suffix = ".jpg";
        int index = path.lastIndexOf(".");
        if (index > 0) {
            suffix = path.substring(index, path.length());
        }
        File snapshot = inputStreamToTmpFile(inputStream, suffix);

        File compressedFile = null;
        compressedFile = CompressImageUtil.compressUtilSmallerThan(35, snapshot, registrar.context());
        if (compressedFile == null) {
            return null;
        }

        result = fileToByteArray(compressedFile);

        return result;
    }

    private static byte[] streamToByteArray(InputStream inputStream) {
        Bitmap bmp = null;
        bmp = BitmapFactory.decodeStream(inputStream);
        return Util.bmpToByteArray(bmp, true);
    }

    private static byte[] fileToByteArray(File file) {
        Bitmap bmp = null;
        bmp = BitmapFactory.decodeFile(file.getAbsolutePath());
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

    private static File inputStreamToTmpFile(InputStream inputStream, String suffix) {
        File file = null;

        BufferedSink sink = null;
        Source source = null;
        OutputStream outputStream = null;
        try {
            file = File.createTempFile(UUID.randomUUID().toString(), suffix);
            outputStream = new FileOutputStream(file);
            sink = Okio.buffer(Okio.sink(outputStream));
            source = Okio.source(inputStream);
            sink.writeAll(source);
            sink.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (sink != null) {
                try {
                    sink.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (source != null) {
                try {
                    source.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return file;
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
