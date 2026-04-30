package com.jarvan.fluwx.handlers

import android.Manifest
import android.app.Activity
import android.app.Fragment
import android.os.Build

/***
 * Created by mo on 2020/3/27
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
class PermissionHandler(private val activity: Activity?) {
    private val tag = "Fragment_TAG"
    private val fragment: Fragment = Fragment()

    fun requestStoragePermission() {
        if (oldFragment != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                oldFragment?.requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), 12121)
            }
        } else {
            activity?.run {
                val ft = fragmentManager.beginTransaction()
                ft.add(fragment, tag)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    ft.commitNow()
                } else {
                    ft.commit()
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    fragment.requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), 12121)
                }
            }
        }
    }

    private val oldFragment get() = activity?.fragmentManager?.findFragmentByTag(tag)
}