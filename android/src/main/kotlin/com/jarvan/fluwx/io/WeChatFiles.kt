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
 * Created by mo on 2020/5/13
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/


class WeChatFileFile(override val source: Any, override val suffix: String) : WeChatFile {
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

private class WeChatAssetFile(override val source: Any, override val suffix: String) : WeChatFile {
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

private class WeChatNetworkFile(override val source: Any, override val suffix: String) : WeChatFile {
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

private class WeChatMemoryFile(override val source: Any, override val suffix: String) : WeChatFile {
    private var internalSource: ByteArray

    init {
        if (source !is ByteArray)
            throw  IllegalArgumentException("source should be String but it's ${source::class.java.name}")
        else
            internalSource = source
    }

    override suspend fun readByteArray(): ByteArray = internalSource
}

interface WeChatFile {
    val source: Any
    val suffix: String

    suspend fun readByteArray(): ByteArray

    companion object {
        //    NETWORK,
//    ASSET,
//    FILE,
//    BINARY,
        fun createWeChatFile(params: Map<String, Any>, assetFileDescriptor: (String) -> AssetFileDescriptor): WeChatFile {
//          Map toMap() => {"source": source, "schema": schema.index, "suffix": suffix};
            val suffix = (params["suffix"] as String?) ?: ".jpeg"
            return when ((params["schema"] as? Int) ?: 0) {
                0 -> WeChatNetworkFile(source = (params["source"] as? String).orEmpty(), suffix = suffix)
                1 -> WeChatAssetFile(source = assetFileDescriptor(((params["source"] as? String).orEmpty())), suffix = suffix)
                2 -> WeChatFileFile(source = File((params["source"] as? String).orEmpty()), suffix = suffix)
                3 -> WeChatMemoryFile(source = (params["source"] as? ByteArray)
                        ?: byteArrayOf(), suffix = suffix)
                else -> WeChatNetworkFile(source = (params["source"] as? String).orEmpty(), suffix = suffix)
            }
        }
    }
}

