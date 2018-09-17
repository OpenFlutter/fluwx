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

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.UUID;

import okio.BufferedSink;
import okio.Okio;
import okio.Source;

public class FileUtil {
    public static File createTmpFile(AssetFileDescriptor fileDescriptor) {
        if (fileDescriptor == null) {
            return null;
        }
        File file = null;
        BufferedSink sink = null;
        Source source = null;
        OutputStream outputStream = null;
        try {
            file = File.createTempFile(UUID.randomUUID().toString(), ".png");
            outputStream = new FileOutputStream(file);
            sink = Okio.buffer(Okio.sink(outputStream));
            source = Okio.source(fileDescriptor.createInputStream());
            sink.writeAll(source);
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
}
