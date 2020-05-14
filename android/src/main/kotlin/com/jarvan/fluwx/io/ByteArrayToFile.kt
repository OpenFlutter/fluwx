package com.jarvan.fluwx.io

import android.content.Context
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okio.*
import java.io.*
import java.util.*

/***
 * Created by mo on 2020/5/13
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/

private const val cachePathName = "fluwxSharedData"

internal suspend fun ByteArray.toExternalCacheFile(context: Context, suffix: String): File? {
    var file: File? = null
    val externalFile = context.externalCacheDir ?: return file
    val dir = File(externalFile.absolutePath + File.separator + cachePathName).apply {
        if (!exists()) {
            mkdirs()
        }
    }
    file = File(dir.absolutePath + File.separator + UUID.randomUUID().toString() + suffix)
    return saveToLocal(this, file)
}

internal suspend fun ByteArray.toCacheFile(context: Context, suffix: String): File? {
    var file: File? = null
    val externalFile = context.cacheDir ?: return file
    val dir = File(externalFile.absolutePath + File.separator + cachePathName).apply {
        if (!exists()) {
            mkdirs()
        }
    }
    file = File(dir.absolutePath + File.separator + UUID.randomUUID().toString() + suffix)
    return saveToLocal(this, file)
}

private suspend fun saveToLocal(byteArray: ByteArray, file: File): File? {
    return withContext(Dispatchers.IO) {

        var sink: BufferedSink? = null
        var source: Source? = null
        var outputStream: OutputStream? = null

        try {


            outputStream = FileOutputStream(file)
            sink = outputStream.sink().buffer()
            source = ByteArrayInputStream(byteArray).source()
            sink.writeAll(source)
            sink.flush()

        } catch (e: IOException) {
            Log.w("Fluwx", "failed to create cache files")
        } finally {
            sink?.close()
            source?.close()
            outputStream?.close()
        }

        file
    }
}
