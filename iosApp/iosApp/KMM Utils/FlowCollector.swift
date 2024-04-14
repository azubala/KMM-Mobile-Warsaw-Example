//
//  Copyright © 2024 Aleksander Zubala. All rights reserved.
//

import Foundation
import shared

public enum CollectorError: Error {
    case valueTypeMismatch
    case unknown
}

public typealias KotlinCoreFlow = Kotlinx_coroutines_coreFlow
public typealias KotlinCoroutineScope = Kotlinx_coroutines_coreCoroutineScope
public typealias KotlinCoreFlowCollector = Kotlinx_coroutines_coreFlowCollector

public class FlowDispatcher {
    open func callAsFunction(collectHandler: @escaping () -> Void) {}
}

public extension FlowDispatcher {
    static func makeDefault() -> FlowDispatcher {
        DefaultFlowDispatcher()
    }

    static func makeMain() -> FlowDispatcher {
        MainThreadFlowDispatcher()
    }
}

public class MainThreadFlowDispatcher: FlowDispatcher {
    public override func callAsFunction(collectHandler: @escaping () -> Void) {
        DispatchQueue.main.async(execute: collectHandler)
    }
}

public class DefaultFlowDispatcher: FlowDispatcher {
    public override func callAsFunction(collectHandler: @escaping () -> Void) {
        collectHandler()
    }
}

public class FlowCollector<T>: KotlinCoreFlowCollector {
    private let dispatcher: FlowDispatcher
    private let emittedValueHandler: (T) -> Void

    public init(
        dispatcher: FlowDispatcher = .makeDefault(),
        emittedValueHandler: @escaping (T) -> Void
    ) {
        self.dispatcher = dispatcher
        self.emittedValueHandler = emittedValueHandler
    }

    public func emit(value: Any?, completionHandler: @escaping (Error?) -> Void) {
        dispatcher { [weak self] in
            guard let self else {
                completionHandler(CollectorError.unknown)
                return
            }
            guard let typedValue = value as? T else {
                completionHandler(CollectorError.valueTypeMismatch)
                return
            }

            emittedValueHandler(typedValue)
            completionHandler(nil)
        }
    }
}

public extension KotlinCoreFlow {
    func collect<T>(dispatcher: FlowDispatcher = .makeMain(),
                    on receiveDispatcher: FlowDispatcher = .makeDefault(),
                    emittedValueHandler: @escaping (T) -> Void,
                    errorHandler: ((Error?) -> Void)? = nil) {
        dispatcher { [weak self] in
            guard let self else { return }
            let flowCollector = FlowCollector<T>(dispatcher: receiveDispatcher,
                                                 emittedValueHandler: emittedValueHandler)

            collect(collector: flowCollector,
                    completionHandler: errorHandler != nil ? errorHandler! : { error in
                guard let error = error else { return }
                NSLog("Failed collecting value with handler: \(type(of: emittedValueHandler)), error: \(error)")
            })
        }
    }
}

