package com.zubala.mobilewarsawexample

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform