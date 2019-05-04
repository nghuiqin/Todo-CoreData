//
//  DataManager.swift
//  Todo
//
//  Created by Ng Hui Qin on 5/4/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//

import Foundation
import CoreData

struct DataManager {
    /// Context to manage object state
    private let context: NSManagedObjectContext

    /// DataManager Initialization
    ///
    /// - Parameter context: NSManagedObjectContext context for persistent container
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    /// Fetch Board's list in order ascending
    ///
    /// - Returns: [Board] list of task board
    func fetchBoardList() -> [Board] {
        let fetchRequest = Board.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to fetch board list with \(error.localizedDescription)")
            return []
        }
    }

    /// Create new board with order
    ///
    /// - Parameters:
    ///   - name: String Board's name
    ///   - order: Int Board's order in collectionView
    /// - Returns: Board Object of created board
    func createNewBoard(name: String, order: Int) -> Board {
        let board = Board(context: context)
        board.name = name
        board.order = Int32(order)
        contextSave()
        return board
    }

    /// Delete board in context
    ///
    /// - Parameter board: Board board to delete
    /// - Returns: [Board] Updated Board's list
    func deleteBoard(board: Board, in boards: [Board]) -> [Board] {
        let index = Int(board.order)
        context.delete(board)
        // Update boards' order
        var newBoards = boards
        newBoards.remove(at: index)
        newBoards.enumerated().forEach({ $1.order = Int32($0) })
        contextSave()
        return newBoards
    }

    /// Update context's object to persistent store
    private func contextSave() {
        do {
            try context.save()
        } catch {
            fatalError("Failed to save context")
        }
    }
}


// MARK: - Task Manager
extension DataManager {

    /// Create Task
    ///
    /// - Parameters:
    ///   - detail: String Task's detail
    ///   - board: Board Board to contain this task
    /// - Returns: Board Board which 
    func createTaskInBoard(detail: String, in board: Board) -> Bool {
        let task = Task(context: context)
        task.detail = detail
        board.addTasksObject(task)
        contextSave()
        return true
    }
}
