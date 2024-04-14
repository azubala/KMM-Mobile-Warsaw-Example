package com.zubala.mobilewarsawexample

import com.zubala.mobilewarsawexample.login.LoginViewModel
import com.zubala.mobilewarsawexample.login.LoginViewStateReducer
import kotlinx.coroutines.MainScope

class SharedSDK {
    private val platform: Platform = getPlatform()

    fun greet(): String {
        return "Hello, ${platform.name}!"
    }

    fun provideLoginViewModel(): LoginViewModel {
        return LoginViewModel(LoginViewStateReducer, MainScope())
    }
}
