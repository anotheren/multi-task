//
//  MultiTaskSnapshot.swift
//  MultiTask
//
//  Created by 刘栋 on 2022/9/23.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public struct MultiTaskSnapshot<Output> {
    
    let update: [Output]
    let offset: Int
    let total: Int
}
