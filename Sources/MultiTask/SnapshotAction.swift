//
//  SnapshotAction.swift
//  MultiTask
//
//  Created by 刘栋 on 2022/9/23.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public enum SnapshotAction: Equatable {
    
    case next
    case cancelled
}

extension SnapshotAction {
    
    public var isNext: Bool {
        switch self {
        case .next:
            return true
        case .cancelled:
            return false
        }
    }
    
    public var isCancelled: Bool {
        switch self {
        case .next:
            return false
        case .cancelled:
            return true
        }
    }
}
