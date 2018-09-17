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

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.text.TextUtils;

import java.io.IOException;

import io.flutter.plugin.common.PluginRegistry;

public final class AssetManagerUtil {
    private AssetManagerUtil() {
        throw new RuntimeException("can't do this");
    }

    public static AssetFileDescriptor openAsset(PluginRegistry.Registrar registrar, String assetKey, String assetPackage) {
        AssetFileDescriptor fd = null;
        AssetManager assetManager = registrar.context().getAssets();
        String key;
        if (TextUtils.isEmpty(assetPackage)) {
            key = registrar.lookupKeyForAsset(assetKey);
        } else {
            key = registrar.lookupKeyForAsset(assetKey, assetPackage);
        }
        try {
            fd = assetManager.openFd(key);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return fd;
    }
}
