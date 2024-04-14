//
//  Copyright © 2024 Aleksander Zubala. All rights reserved.
//

import SwiftUI
import shared

@main
struct iOSApp: App {
	var body: some Scene {
		WindowGroup {
            LoginView(viewModel: SharedSDK().provideLoginViewModel())
		}
	}
}
