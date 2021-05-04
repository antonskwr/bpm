//
//  SyncOperationQueue.swift
//  BPM
//
//  Created by Anton Skvartsou on 5/4/21.
//  Copyright © 2021 Anton Skvartsou. All rights reserved.
//

import Foundation

class SyncOperationQueue: OperationQueue {
    func run(startBlock: BlockOperation, completionBlock: BlockOperation) {
        completionBlock.addDependency(startBlock)
        addOperation(startBlock)
        addOperation(completionBlock)
    }
}
