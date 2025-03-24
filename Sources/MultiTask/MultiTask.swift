//
//  MultiTask.swift
//  MultiTask
//
//  Created by 刘栋 on 2022/9/23.
//  Copyright © 2022 anotheren.com. All rights reserved.
//

import Foundation

public struct MultiTask {
    
    @discardableResult
    public static func withThrowingTask<Input, Output, Inputs: Collection>(
        inputs: Inputs,
        output: Output.Type = Output.self,
        step: Int = 16,
        childTask: @escaping (Input) async throws -> Output,
        progressHandle: @escaping (Snapshot<Output>) async throws -> SnapshotAction = { _ in return .next }
    ) async throws -> [Output] where Inputs.Element == Input, Inputs.Index == Int {
        var finalResults: [Output] = []
        let total = inputs.count
        for index in stride(from: 0, to: total, by: step) {
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
            let snapshot = Snapshot<Output>(update: progressResults, offset: offset, total: total)
            let action = try await progressHandle(snapshot)
            if action.isCancelled {
                break
            }
        }
        
        return finalResults
    }
    
    @discardableResult
    public static func withThrowingArrayTask<Input, Output, Inputs: Collection>(
        inputs: Inputs,
        output: Output.Type = Output.self,
        step: Int = 16,
        childTask: @escaping (Input) async throws -> Array<Output>,
        progressHandle: @escaping (Snapshot<Output>) async throws -> SnapshotAction = { _ in return .next }
    ) async throws -> [Output] where Inputs.Element == Input, Inputs.Index == Int {
        var finalResults: [Output] = []
        let total = inputs.count
        for index in stride(from: 0, to: total, by: step) {
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
            let snapshot = Snapshot<Output>(update: progressResults, offset: offset, total: total)
            let action = try await progressHandle(snapshot)
            if action.isCancelled {
                break
            }
        }
        
        return finalResults
    }
}
