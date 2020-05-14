package com.jarvan.fluwx.io

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Bitmap.CompressFormat
import android.graphics.BitmapFactory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okio.*
import top.zibin.luban.Luban
import java.io.*
import java.util.*
import kotlin.math.sqrt

/***
 * Created by mo on 2020/3/7
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
class ImagesIOIml(override val image: WeChatFile) : ImagesIO {

    override suspend fun readByteArray(): ByteArray = image.readByteArray()

    override suspend fun compressedByteArray(context: Context, maxSize: Int): ByteArray = withContext(Dispatchers.IO) {
        val originalByteArray = readByteArray()
        if (originalByteArray.isEmpty())
            return@withContext originalByteArray

        val originFile = inputStreamToFile(ByteArrayInputStream(originalByteArray))
        val compressedFile = Luban
                .with(context)
                .ignoreBy(maxSize)
                .setTargetDir(context.cacheDir.absolutePath)
                .get(originFile.absolutePath)

        if (compressedFile.length() < maxSize) {
            val source = compressedFile.source()
            val bufferedSource = source.buffer()
            val bytes = bufferedSource.readByteArray()
            source.close()
            bufferedSource.close()
            bytes
        } else {
            createScaledBitmapWithRatio(compressedFile, maxSize)
        }
    }

    private fun inputStreamToFile(inputStream: InputStream): File {
        val file = File.createTempFile(UUID.randomUUID().toString(), image.suffix)

        val outputStream: OutputStream = FileOutputStream(file)
        val sink = outputStream.sink().buffer()
        val source = inputStream.source()
        sink.writeAll(source)
        source.close()
        sink.close()

        return file
    }

    private fun createScaledBitmapWithRatio(file: File, maxSize: Int): ByteArray {
        val originBitmap = BitmapFactory.decodeFile(file.absolutePath)
        val result: Bitmap? = createScaledBitmapWithRatio(originBitmap, maxSize, true)
        result ?: return byteArrayOf()

        return bmpToByteArray(result, image.suffix) ?: byteArrayOf()
    }

    private fun createScaledBitmapWithRatio(bitmap: Bitmap, maxLength: Int, recycle: Boolean): Bitmap? {
        var result = bitmap
        while (true) {
            val ratio = maxLength.toDouble() / result.byteCount
            val width = result.width * sqrt(ratio)
            val height = result.height * sqrt(ratio)
            val tmp = Bitmap.createScaledBitmap(result, width.toInt(), height.toInt(), true)
            if (result != bitmap) {
                result.recycle()
            }
            result = tmp
            if (result.byteCount < maxLength) {
                break
            }
        }
        if (recycle) {
            bitmap.recycle()
        }
        return result
    }

    private fun bmpToByteArray(bitmap: Bitmap, suffix: String): ByteArray? { //        int bytes = bitmap.getByteCount();

        val byteArrayOutputStream = ByteArrayOutputStream()
        var format = CompressFormat.PNG
        if (suffix.toLowerCase(Locale.US) == ".jpg" || suffix.toLowerCase(Locale.US) == ".jpeg") {
            format = CompressFormat.JPEG
        }
        bitmap.compress(format, 100, byteArrayOutputStream)
        val inputStream: InputStream = ByteArrayInputStream(byteArrayOutputStream.toByteArray())
        var result: ByteArray? = null

        bitmap.recycle()

        val source = inputStream.source()
        val bufferedSource = source.buffer()
        try {
            result = bufferedSource.readByteArray()
            source.close()
            bufferedSource.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return result
    }
}

interface ImagesIO {
    val image: WeChatFile
    suspend fun readByteArray(): ByteArray
    suspend fun compressedByteArray(context: Context, maxSize: Int): ByteArray
}
