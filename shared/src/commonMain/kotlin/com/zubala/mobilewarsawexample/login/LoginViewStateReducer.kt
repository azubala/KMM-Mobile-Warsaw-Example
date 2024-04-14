package com.zubala.mobilewarsawexample.login

object LoginViewStateReducer {
    fun reduce(state: LoginViewState, partialState: PartialLoginViewState) : LoginViewState =
        when (partialState) {
            is PartialLoginViewState.Username -> state.copy(username = partialState)
            is PartialLoginViewState.Password -> state.copy(password = partialState)
            is PartialLoginViewState.LoginButtonEnabled -> state.copy(loginButtonEnabled = partialState)
            is PartialLoginViewState.LoggedInUser -> state.copy(loggedInUser = partialState)
        }
}
