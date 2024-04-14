//
//  Copyright © 2024 Aleksander Zubala. All rights reserved.
//

import Foundation
import Combine

public protocol ObservableViewModel: ObservableObject {
    associatedtype StateType
    associatedtype EventType

    var currentState: StateType { get }

    var state: KotlinCoreFlow { get }
    var event: KotlinCoreFlow { get }

    func collectState(onNewState: ((StateType) -> Void)?)
    func collectEvent(onNewEvent: @escaping (_ event: EventType) -> Void)
}

public extension ObservableViewModel where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    func collectState() {
        collectState(onNewState: nil)
    }

    func collectState(onNewState: ((StateType) -> Void)?) {
        state.collect { [weak self] (newState: StateType) in
            onNewState?(newState)
            self?.objectWillChange.send()
        }
    }

    func collectEvent(onNewEvent: @escaping (_ event: EventType) -> Void) {
        event.collect { (event: EventType) in
            onNewEvent(event)
        }
    }
}
