//
//  Snapshot.swift
//  MultiTask
//
//  Created by 刘栋 on 2022/9/23.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public struct Snapshot<Output> {
    
    public let update: [Output]
    public let offset: Int
    public let total: Int
}
