package com.zubala.mobilewarsawexample.login

data class LoginViewState(
    val username: PartialLoginViewState.Username = PartialLoginViewState.Username(),
    val password: PartialLoginViewState.Password = PartialLoginViewState.Password(),
    val loginButtonEnabled: PartialLoginViewState.LoginButtonEnabled = PartialLoginViewState.LoginButtonEnabled(),
    val loggedInUser: PartialLoginViewState.LoggedInUser = PartialLoginViewState.LoggedInUser()
)

sealed interface PartialLoginViewState {
    data class Username(val data: String = "") : PartialLoginViewState
    data class Password(val data: String = "") : PartialLoginViewState
    data class LoginButtonEnabled(val data: Boolean = false) : PartialLoginViewState
    data class LoggedInUser(val data: User? = null) : PartialLoginViewState
}
