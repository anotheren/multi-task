//
//  MultiTask.swift
//  MultiTask
//
//  Created by 刘栋 on 2022/9/23.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public struct MultiTask<Input, Output> {
    
    @discardableResult
    public static func withThrowingTask<Input, Output>(
        inputs: [Input],
        step: Int = 16,
        childTask: @escaping (Input) async throws -> Output,
        progressHandle: @escaping (MultiTaskSnapshot<Output>) async throws -> MultiTaskSnapshotAction = { _ in return .next }
    ) async throws -> [Output] {
        var finalResults: [Output] = []
        let total = inputs.count
        for index in stride(from: 0, to: total, by: step) {
            let start = Date.now
            let progressResults = try await withThrowingTaskGroup(of: Output.self, body: { taskGroup in
                for idx in index..<index+step where idx < total {
                    taskGroup.addTask {
                        try await childTask(inputs[idx])
                    }
                }
                var results = [Output]()
                for try await result in taskGroup {
                    results.append(result)
                }
                return results
            })
            
            finalResults.append(contentsOf: progressResults)
            
            let offset = index+step-1 < total ? index+step-1 : total - 1
            let snapshot = MultiTaskSnapshot<Output>(update: progressResults, offset: offset, total: total)
            let action = try await progressHandle(snapshot)
            if case .cancel = action {
                break
            } else if case .nextWithInterval(let timeInterval) = action {
                let end = Date.now
                let sleepTime = timeInterval - (end.timeIntervalSince1970-start.timeIntervalSince1970)
                if sleepTime > 0 {
                    let nanoseconds: UInt64 = UInt64(sleepTime * TimeInterval(NSEC_PER_SEC))
                    try await Task.sleep(nanoseconds: nanoseconds)
                }
            }
        }
        
        return finalResults
    }
    
    @discardableResult
    public static func withThrowingArrayTask<Input, Output>(
        inputs: [Input],
        step: Int = 16,
        childTask: @escaping (Input) async throws -> Array<Output>,
        progressHandle: @escaping (MultiTaskSnapshot<Output>) async throws -> MultiTaskSnapshotAction = { _ in return .next }
    ) async throws -> [Output] {
        var finalResults: [Output] = []
        let total = inputs.count
        for index in stride(from: 0, to: total, by: step) {
            let start = Date.now
            let progressResults = try await withThrowingTaskGroup(of: Array<Output>.self, body: { taskGroup in
                for idx in index..<index+step where idx < total {
                    taskGroup.addTask {
                        try await childTask(inputs[idx])
                    }
                }
                var results = [Output]()
                for try await result in taskGroup {
                    results.append(contentsOf: result)
                }
                return results
            })
            
            finalResults.append(contentsOf: progressResults)
            
            let offset = index+step-1 < total ? index+step-1 : total - 1
            let snapshot = MultiTaskSnapshot<Output>(update: progressResults, offset: offset, total: total)
            let action = try await progressHandle(snapshot)
            if case .cancel = action {
                break
            } else if case .nextWithInterval(let timeInterval) = action {
                let end = Date.now
                let sleepTime = timeInterval - (end.timeIntervalSince1970-start.timeIntervalSince1970)
                if sleepTime > 0 {
                    let nanoseconds: UInt64 = UInt64(sleepTime * TimeInterval(NSEC_PER_SEC))
                    try await Task.sleep(nanoseconds: nanoseconds)
                }
            }
        }
        
        return finalResults
    }
}
