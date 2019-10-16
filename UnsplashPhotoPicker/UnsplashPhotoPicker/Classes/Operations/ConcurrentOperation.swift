//
//  ConcurrentOperation.swift
//
//  Created by Francois Courville on 2016-12-27.
//  Copyright © 2016 FrankCourville.com. All rights reserved.
//

import Foundation

class ConcurrentOperation: Operation {
    private var overrideExecuting: Bool = false
    private var overrideFinished: Bool = false

    var error: Error?

    override var isExecuting: Bool {
        get { return overrideExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            overrideExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    override var isFinished: Bool {
        get { return overrideFinished }
        set {
            willChangeValue(forKey: "isFinished")
            overrideFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    override func start() {
        isExecuting = true

        if isCancelled || hasCancelledDependency() {
            cancel()
            completeOperation()
            return
        }

        main()
    }

    final func complete(with error: Error) {
        self.error = error
        cancelAndCompleteOperation()
    }

    func cancelAndCompleteOperation() {
        cancel()
        completeOperation()
    }

    func completeOperation() {
        isExecuting = false
        isFinished = true
    }

}

extension Operation {
    func hasCancelledDependency() -> Bool {
        for operation in dependencies where operation.isCancelled { return true }
        return false
    }
}
