package com.jarvan.fluwx.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

public class ThumbnailCompressUtil {

    /*** 图片压缩比例计算**
     * @param options BitmapFactory.Options* @param minSideLength 小边长，单位为像素，如果为-1，则不按照边来压缩图片*
     * @param maxNumOfPixels 这张片图片最大像素值，单位为byte，如100*1024* @return 压缩比例,必须为2的次幂*/
    public static int computeSampleSize(BitmapFactory.Options options, int minSideLength, int maxNumOfPixels) {
        int initialSize = computeInitialSampleSize(options, minSideLength, maxNumOfPixels);
        int roundedSize;
        if (initialSize <= 8) {
            roundedSize = 1;
            while (roundedSize < initialSize) {
                roundedSize <<= 1;
            }
        } else {
            roundedSize = (initialSize + 7) / 8 * 8;
        }
        return roundedSize;
    }

    /*** 计算图片的压缩比例，用于图片压缩
     * * @param options BitmapFactory.Options* @param minSideLength 小边长，单位为像素，如果为-1，则不按照边来压缩图片
     * * @param maxNumOfPixels 这张片图片最大像素值，单位为byte，如100*1024*
     * @return 压缩比例*/
    private static int computeInitialSampleSize(BitmapFactory.Options options, int minSideLength, int maxNumOfPixels) {
        double w = options.outWidth;
        double h = options.outHeight;
        int lowerBound = (maxNumOfPixels == -1) ? 1 : (int) Math.ceil(Math.sqrt(w * h / maxNumOfPixels));
        int upperBound = (minSideLength == -1) ? 128 : (int) Math.min(Math.floor(w / minSideLength), Math.floor(h / minSideLength));
        if (upperBound < lowerBound) {
            return lowerBound;
        }
        if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
            return 1;
        } else if (minSideLength == -1) {
            return lowerBound;
        } else {
            return upperBound;
        }
    }

    public static Bitmap makeNormalBitmap(String nativeImagePath, int minSideLength, int maxNumOfPixels) {
        return makeNormalBitmap(nativeImagePath, minSideLength, maxNumOfPixels, Bitmap.Config.ARGB_4444);
    }

    public static Bitmap makeNormalBitmap(String nativeImagePath, int minSideLength, int maxNumOfPixels, Bitmap.Config config) {
        Bitmap.CompressFormat format = Bitmap.CompressFormat.JPEG;
        if (nativeImagePath.toLowerCase().endsWith(".png")) {
            format = Bitmap.CompressFormat.PNG;
        }
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        Bitmap bitmap = BitmapFactory.decodeFile(nativeImagePath);
//        BitmapFactory.Options options = new BitmapFactory.Options();
//        options.inPreferredConfig = config;
//        options.outHeight = bitmap.getHeight();
//        options.outWidth = bitmap.getWidth();
//        int quality = computeSampleSize(options, minSideLength, maxNumOfPixels);
//        bitmap.compress(format, quality, baos);
//
//        byte[] bytes = baos.toByteArray();
//        bitmap.recycle();
//        Bitmap result = BitmapFactory.decodeByteArray(bytes, 0, bytes.length, null);
//        try {
//            baos.close();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        //质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        Bitmap bitmap = BitmapFactory.decodeFile(nativeImagePath);
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);
        int options = 100; //此处可尝试用90%开始压缩，跳过100%压缩
        // 循环判断如果压缩后图片是否大于100kb,大于继续压缩
        int length;
        while ((length = baos.toByteArray().length) / 1024 > 32) {
            // 每次都减少10
            options -= 10;

            // 重置baos即清空baos
            baos.reset();
            // 这里压缩options%，把压缩后的数据存放到baos中
            if (options <= 0) {
                options = 0;
            }
            bitmap.compress(Bitmap.CompressFormat.JPEG, options, baos);

            if (options == 0) {
                break;
            }

        }


        return bitmap;
    }

    public static Bitmap compress(String nativeImagePath) {
        Bitmap.CompressFormat format = Bitmap.CompressFormat.JPEG;
        if (nativeImagePath.toLowerCase().endsWith(".png")) {
            format = Bitmap.CompressFormat.PNG;
        }
        Log.e("tag", nativeImagePath);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Bitmap bitmap = BitmapFactory.decodeFile(nativeImagePath);
        bitmap.compress(format, 90, baos);
        byte[] bytes = baos.toByteArray();
        bitmap.recycle();
        Bitmap result = BitmapFactory.decodeByteArray(bytes, 0, bytes.length, null);
        try {
            baos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static Bitmap createScaledBitmapWithRatio(Bitmap bitmap, float thumbWidth, boolean recycle) {
        Bitmap thumb;
        int imagw = bitmap.getWidth();
        int imagh = bitmap.getHeight();

        if (imagh > imagw) {
            int height = (int) (imagh * thumbWidth / imagw);
            thumb = Bitmap.createScaledBitmap(bitmap, (int) thumbWidth, height, true);
        } else {
            int width = (int) (imagw * thumbWidth / imagh);
            thumb = Bitmap.createScaledBitmap(bitmap, width, (int) thumbWidth, true);
        }

        if (recycle) {
            bitmap.recycle();
        }

        return thumb;
    }

    public static Bitmap createScaledBitmap(Bitmap bitmap, int size, boolean recycle) {
        Bitmap thumb;
        thumb = Bitmap.createScaledBitmap(bitmap, size, size, true);

        if (recycle) {
            bitmap.recycle();
        }

        return thumb;
    }


    public static Bitmap createScaledBitmapWithRatio(Bitmap bitmap, int maxLength, boolean recycle) {

        Bitmap result = bitmap;
        while (true) {
            double ratio = ((double) maxLength) / result.getByteCount();
            double width = result.getWidth() * Math.sqrt(ratio);
            double height = result.getHeight() * Math.sqrt(ratio);
            Bitmap tmp = Bitmap.createScaledBitmap(result, (int) width, (int) height, true);
            if (result != bitmap) {
                result.recycle();
            }
            result = tmp;

            if (result.getByteCount() < maxLength) {
                break;
            }

        }

        if (recycle) {
            bitmap.recycle();
        }

        return result;

    }

}
