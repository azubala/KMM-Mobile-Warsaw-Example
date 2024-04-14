package com.zubala.mobilewarsawexample.login

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class LoginViewModel(
    private val viewStateReducer: LoginViewStateReducer,
    private val scope: CoroutineScope
) {
    // View State
    private val initialState: LoginViewState by lazy { createInitialState() }

    private val _state: MutableStateFlow<LoginViewState> by lazy {
        MutableStateFlow(initialState)
    }
    val state: Flow<LoginViewState> = _state.asStateFlow()

    val currentState: LoginViewState
        get() = _state.value

    private fun createInitialState(): LoginViewState =
        LoginViewState(
            username = PartialLoginViewState.Username(),
            password = PartialLoginViewState.Password(),
            loginButtonEnabled = PartialLoginViewState.LoginButtonEnabled(),
            loggedInUser = PartialLoginViewState.LoggedInUser()
        )

    // View Events
    private val _event: MutableSharedFlow<LoginViewEvent> = MutableSharedFlow()
    val event: Flow<LoginViewEvent> = _event.asSharedFlow()

    protected fun emitEvent(event: LoginViewEvent) = scope.launch {
        _event.emit(event)
    }

    // Intents
    fun updateUsername(username: String) {
        setViewState(
            viewStateReducer.reduce(currentState, PartialLoginViewState.Username(username))
        )
        setViewState(
            viewStateReducer.reduce(
                currentState,
                PartialLoginViewState.LoginButtonEnabled(credentialsValid())
            )
        )
    }

    fun updatePassword(password: String) {
        setViewState(
            viewStateReducer.reduce(currentState, PartialLoginViewState.Password(password))
        )
        setViewState(
            viewStateReducer.reduce(
                currentState,
                PartialLoginViewState.LoginButtonEnabled(credentialsValid())
            )
        )
    }

    fun performLogin() {
        // call use case to perform login
        // use case may inside call API
        // API return JSON which we serialise to UserDTO
        // DTO is mapped to domain User
        val user = User(id = "42", displayName = "John Appleseed")
        setViewState(viewStateReducer.reduce(currentState, PartialLoginViewState.LoggedInUser(user)))
        emitEvent(LoginViewEvent.AskForTrackingPermission)
    }

    private fun setViewState(viewState: LoginViewState) {
        _state.tryEmit(viewState)
    }

    private fun credentialsValid(): Boolean =
        currentState.username.data.isNotEmpty() && currentState.password.data.isNotEmpty()

}
