//
//  MultiTaskSnapshotAction.swift
//  MultiTask
//
//  Created by 刘栋 on 2022/9/23.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public enum MultiTaskSnapshotAction: Equatable {
    
    case next
    case nextWithInterval(TimeInterval)
    case cancel
}
