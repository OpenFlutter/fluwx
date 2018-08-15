package com.jarvan.fluwx.utils;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import top.zibin.luban.Luban;
import top.zibin.luban.OnCompressListener;

class CompressImageUtil {
    private CompressImageUtil() {
    }

    public static File compressUtilSmallerThan(int size, File file, Context context) {

        final boolean[] run = new boolean[]{true};
        File result = null;
        final File[] tmp = new File[]{file};
        List<File> dirtyFiles = new ArrayList<>();
        try {


            while (tmp[0].length() > size * 1024 && run[0]) {

                Log.e("--","runing " + tmp[0].length());
                List<File> compressedFiles = Luban.with(context)
                        .ignoreBy(size)
                        .load(tmp[0])
                        .setTargetDir(context.getCacheDir().getAbsolutePath())
                        .setCompressListener(new OnCompressListener() {
                            @Override
                            public void onStart() {

                            }

                            @Override
                            public void onSuccess(File file) {
                                Log.e("---->",file.getAbsolutePath());
                                tmp[0] = file;
                            }

                            @Override
                            public void onError(Throwable e) {
                                Log.e("--->done",e.getMessage());
                                run[0] = false;
                            }
                        })
                        .get();
                dirtyFiles.add(tmp[0]);
            }

            result = tmp[0];

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
