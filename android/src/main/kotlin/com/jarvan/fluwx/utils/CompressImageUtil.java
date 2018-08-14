package com.jarvan.fluwx.utils;

import android.content.Context;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import top.zibin.luban.Luban;

class CompressImageUtil {
    private CompressImageUtil() {
    }

    public static File compressUtilSmallerThan(int size, File file, Context context) {

        File result = null;
        File tmp = file;
        List<File> dirtyFiles = new ArrayList<>();
        try {

            while (tmp.length() > size * 1024) {
                List<File> compressedFiles = Luban.with(context)
                        .ignoreBy(size)
                        .load(tmp)
                        .setTargetDir(context.getCacheDir().getAbsolutePath())
                        .get();
                tmp = compressedFiles.get(0);
                dirtyFiles.add(tmp);
            }

            result = tmp;

        } catch (IOException e) {
            e.printStackTrace();
        }

        for (File dirtyFile : dirtyFiles) {
            if (dirtyFile != result) {
                dirtyFile.delete();
            }
        }
        return result;
    }
}
