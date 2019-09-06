/*
 * Copyright (C) 2018 The OpenFlutter Organization
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.jarvan.fluwx.utils;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

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

public class ShareImageUtil {

    final static int WX_MAX_IMAGE_BYTE_SIZE = 10485760;

    public static byte[] getImageData(PluginRegistry.Registrar registrar, String path) {
        byte[] result = null;
        if (path.startsWith(WeChatPluginImageSchema.SCHEMA_ASSETS)) {
            String key = path.substring(WeChatPluginImageSchema.SCHEMA_ASSETS.length());
            AssetFileDescriptor fileDescriptor = AssetManagerUtil.openAsset(registrar, key, getPackage(key));
            try {
                InputStream inputStream = fileDescriptor.createInputStream();
                result = streamToByteArray(inputStream);
            } catch (IOException e) {
                e.printStackTrace();
            }

        } else if (path.startsWith(WeChatPluginImageSchema.SCHEMA_FILE)) {
            String pathWithoutUri = path.substring("file://".length());
            result = fileToByteArray(registrar, pathWithoutUri);
        } else if (path.startsWith(WeChatPluginImageSchema.SCHEMA_CONTENT)) {
            File file = getFileFromContentProvider(registrar, path);
            if (file != null) {
                result = fileToByteArray(registrar, file.getAbsolutePath());
            }
        } else {
//            result = handleNetworkImage(registrar, path);
            result = Util.inputStreamToByte(openStream(path));
        }

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

    private static byte[] fileToByteArray(PluginRegistry.Registrar registrar, String pathWithoutUri) {

        byte[] result = null;
        Bitmap bmp = null;
        bmp = BitmapFactory.decodeFile(pathWithoutUri);

        int byteCount;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            byteCount = bmp.getAllocationByteCount();
        } else {
            byteCount = bmp.getByteCount();
        }
        if (byteCount >= WX_MAX_IMAGE_BYTE_SIZE) {
            result = Util.bmpToCompressedByteArray(bmp, Bitmap.CompressFormat.JPEG, true);
        } else {
            result = Util.bmpToByteArray(bmp, true);
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

    public static File inputStreamToFile(InputStream inputStream, String suffix, Context context) {

        File file = null;

        BufferedSink sink = null;
        Source source = null;
        OutputStream outputStream = null;
        try {

            File externalFile = context.getExternalCacheDir();
            if (externalFile == null) {
                return null;
            }
            file = new File(externalFile.getAbsolutePath() + File.separator + UUID.randomUUID().toString() + suffix);


//            file = File.createTempFile(UUID.randomUUID().toString(), suffix);
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
        if (!url.startsWith("https") && !url.startsWith("http")) {
            url = "http://" + url;
        }
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

    private static File getFileFromContentProvider(PluginRegistry.Registrar registrar, String path) {
        Source source = null;
        BufferedSink sink = null;

        File file = null;
        try {
            Context context = registrar.context().getApplicationContext();
            Uri uri = Uri.parse(path);
            String suffix = null;
            String mimeType = context.getContentResolver().getType(uri);
            if (TextUtils.equals(mimeType, "image/jpeg") || TextUtils.equals(mimeType, "image/jpg")) {
                suffix = ".jpg";
            } else if (TextUtils.equals(mimeType, "image/png")) {
                suffix = ".png";
            }


            file = File.createTempFile(UUID.randomUUID().toString(), suffix);
            InputStream inputStream = context.getContentResolver().openInputStream(uri);

            if (inputStream == null) {
                return null;
            }
            OutputStream outputStream = new FileOutputStream(file);
            sink = Okio.buffer(Okio.sink(outputStream));
            source = Okio.source(inputStream);
            sink.writeAll(source);
            source.close();
            sink.close();
        } catch (IOException e) {
            Log.i("fluwx", "reading image failed:\n" + e.getMessage());
        }

        return file;
    }
}
