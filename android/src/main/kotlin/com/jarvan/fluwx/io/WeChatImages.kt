package com.jarvan.fluwx.io

import android.content.res.AssetFileDescriptor
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import okio.BufferedSource
import okio.buffer
import okio.source
import java.io.File
import java.io.FileNotFoundException
import java.io.IOException


/***
 * Created by mo on 2020/3/7
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/

class WeChatFileImage(override val source: Any, override val suffix: String) : WeChatImage {
    private var internalSource: File

    init {
        if (source !is File)
            throw  IllegalArgumentException("source should be File but it's ${source::class.java.name}")
        else
            internalSource = source
    }

    override suspend fun readByteArray(): ByteArray = withContext(Dispatchers.IO) {
        var source: BufferedSource? = null
        try {
            source = internalSource.source().buffer()
            val array = source.readByteArray()
            array
        } catch (e: FileNotFoundException) {
            byteArrayOf()
        } catch (io: IOException) {
            byteArrayOf()
        } finally {
            source?.close()
        }
    }
}

private class WeChatAssetImage(override val source: Any, override val suffix: String) : WeChatImage {
    private var internalSource: AssetFileDescriptor

    init {
        if (source !is AssetFileDescriptor)
            throw  IllegalArgumentException("source should be AssetFileDescriptor but it's ${source::class.java.name}")
        else
            internalSource = source
    }

    override suspend fun readByteArray(): ByteArray = withContext(Dispatchers.IO) {
        var source: BufferedSource? = null
        try {
            source = internalSource.createInputStream().source().buffer()
            val array = source.readByteArray()
            array
        } catch (e: FileNotFoundException) {
            byteArrayOf()
        } catch (io: IOException) {
            byteArrayOf()
        } finally {
            source?.close()
        }
    }
}

private class WeChatNetworkImage(override val source: Any, override val suffix: String) : WeChatImage {
    private var internalSource: String

    init {
        if (source !is String)
            throw  IllegalArgumentException("source should be String but it's ${source::class.java.name}")
        else
            internalSource = source
    }

    override suspend fun readByteArray(): ByteArray = withContext(Dispatchers.IO) {
        val okHttpClient = OkHttpClient.Builder().build()
        val request: Request = Request.Builder().url(internalSource).get().build()
        try {
            val response = okHttpClient.newCall(request).execute()
            val responseBody = response.body
            if (response.isSuccessful && responseBody != null) {
                responseBody.bytes()
            } else {
                byteArrayOf()
            }
        } catch (e: IOException) {
            Log.w("Fluwx", "reading file from $internalSource failed")
            byteArrayOf()
        }
    }
}

private class WeChatMemoryImage(override val source: Any, override val suffix: String) : WeChatImage {
    private var internalSource: ByteArray

    init {
        if (source !is ByteArray)
            throw  IllegalArgumentException("source should be String but it's ${source::class.java.name}")
        else
            internalSource = source
    }

    override suspend fun readByteArray(): ByteArray = internalSource
}

interface WeChatImage {
    val source: Any
    val suffix: String

    suspend fun readByteArray(): ByteArray

    companion object {
        //    NETWORK,
//    ASSET,
//    FILE,
//    BINARY,
        fun createWeChatImage(params: Map<String, Any>, assetFileDescriptor: (String) -> AssetFileDescriptor): WeChatImage {
//          Map toMap() => {"source": source, "schema": schema.index, "suffix": suffix};
            val suffix = (params["suffix"] as String?) ?: ".jpeg"
            return when ((params["schema"] as? Int) ?: 0) {
                0 -> WeChatNetworkImage(source = (params["source"] as? String).orEmpty(), suffix = suffix)
                1 -> WeChatAssetImage(source = assetFileDescriptor(((params["source"] as? String).orEmpty())), suffix = suffix)
                2 -> WeChatFileImage(source = File((params["source"] as? String).orEmpty()), suffix = suffix)
                3 -> WeChatMemoryImage(source = (params["source"] as? ByteArray)
                        ?: byteArrayOf(), suffix = suffix)
                else -> WeChatNetworkImage(source = (params["source"] as? String).orEmpty(), suffix = suffix)
            }
        }
    }
}

