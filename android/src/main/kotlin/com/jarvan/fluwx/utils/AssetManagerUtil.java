package com.jarvan.fluwx.utils;

import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;

import java.io.IOException;

import io.flutter.plugin.common.PluginRegistry;

public final class AssetManagerUtil {
    private AssetManagerUtil() {
        throw new RuntimeException("can't do this");
    }

    public static AssetFileDescriptor openAsset(PluginRegistry.Registrar registrar, String assetKey, String assetPackage) {
        AssetFileDescriptor fd = null;
        AssetManager assetManager = registrar.context().getAssets();
        String key = registrar.lookupKeyForAsset(assetKey, assetPackage);
        try {
            fd = assetManager.openFd(key);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return fd;
    }
}
