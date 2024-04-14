//
//  Copyright © 2024 Aleksander Zubala. All rights reserved.
//

import SwiftUI
import shared

struct UserDetailsView: View {
    let user: User

    var body: some View {
        VStack {
            Text("Hello \(user.displayName) 👋")
                .font(.title)
        }
    }
}
