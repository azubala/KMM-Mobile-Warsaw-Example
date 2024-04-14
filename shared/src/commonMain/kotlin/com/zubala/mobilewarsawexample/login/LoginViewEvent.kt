package com.zubala.mobilewarsawexample.login

open class ViewEvent {
    object Dismiss : ViewEvent()
}

open class LoginViewEvent : ViewEvent() {
    object AskForTrackingPermission : LoginViewEvent()
}
