//
//  Copyright © 2024 Aleksander Zubala. All rights reserved.
//

import SwiftUI
import shared

extension LoginViewModel: ObservableViewModel {
    public typealias StateType = LoginViewState
    public typealias EventType = LoginViewEvent
}

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    private var state: LoginViewState { viewModel.currentState }

    private var providedUsername: Binding<String> {
        Binding<String>(get: { state.username.data }, set: { viewModel.updateUsername(username: $0) })
    }

    private var providedPassword: Binding<String> {
        Binding<String>(get: { state.password.data }, set: { viewModel.updatePassword(password: $0) })
    }

    private var shouldShowUserDetails: Binding<Bool> {
        Binding<Bool>(get: { state.loggedInUser.data != nil }, set: { _ in })
    }

	var body: some View {
        VStack {
            Text("Mobile Warsaw")
                .font(.title)
            
            TextField("Username", text: providedUsername)

            SecureField("Passowrd", text: providedPassword)
            Button("Login") {
                viewModel.performLogin()
            }
            .disabled(!state.loginButtonEnabled.data)
        }
        .padding()
        .onAppear {
            viewModel.collectState() { newState in
                NSLog("[DEBUG] new state: \(newState)")
            }

            viewModel.collectEvent { event in
                NSLog("[DEBUG] got event: \(event)")
                if event == LoginViewEvent.AskForTrackingPermission.shared {
                    // Show tracking alert
                }
            }
        }
        .fullScreenCover(isPresented: shouldShowUserDetails) {
            UserDetailsView(user: state.loggedInUser.data!) // user must be provided at this point
        }
	}
}


