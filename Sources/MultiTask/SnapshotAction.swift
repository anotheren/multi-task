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
    case cancel
}

extension SnapshotAction {
    
    public var isNext: Bool {
        switch self {
        case .next:
            return true
        case .cancel:
            return false
        }
    }
    
    public var isCancel: Bool {
        switch self {
        case .next:
            return false
        case .cancel:
            return true
        }
    }
}
