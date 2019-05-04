//
//  TodoViewController.swift
//  Todo
//
//  Created by Ng Hui Qin on 5/1/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController {

    /// CollectionView with flowLayout
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(
            width: 300,
            height: UIScreen.main.bounds.height - 200
        )
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: UIScreen.main.bounds,
            collectionViewLayout: flowLayout
        )
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 10,
            right: 20
        )
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: "BoardCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    /// Add Button on Navigation's right
    /// Function: Create New Board
    private let addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(TodoViewController.showAddBoardAlert))
        return addButton
    }()

    /// Board's Array
    private var boards: [Board] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private let dataManager: DataManager

    init(context: NSManagedObjectContext) {
        self.dataManager = DataManager(context: context)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        boards = dataManager.fetchBoardList()
    }

    // MARK: Initialization
    private func viewSetup() {
        title = NSLocalizedString("Kanban", comment: "")
        navigationItem.rightBarButtonItem = addButton
        addButton.target = self

        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.frame = UIScreen.main.bounds
    }

    // MARK: Alert
    @objc func showAddBoardAlert() {
        showTextFieldAlert(
            title: "Add a New board",
            message: "Please insert your board name:",
            placeHolder: "Board Name"
        ) { [weak self] boardName in
            // Create board with name is not empty
            guard !boardName.isEmpty else { return }
            self?.createNewBoard(name: boardName)
        }
    }

    func showAddTaskAlert(for board: Board, at boardCell: BoardCollectionViewCell) {
        showTextFieldAlert(
            title: "Add a New task",
            message: "Please insert your task name:",
            placeHolder: "Task Name"
        ) { [weak self] taskName in
            // Create board with name is not empty
            guard !taskName.isEmpty else { return }
            self?.addNewTask(detail: taskName, into: board, at: boardCell)
        }
    }

    /// TextField Alert Controller
    ///
    /// - Parameters:
    ///   - title: String Title
    ///   - message: String Message
    ///   - placeHolder: String TextField's placeholder
    ///   - actionHandler: ((String) -> Void)? TextField's text will be passed back
    fileprivate func showTextFieldAlert(
        title: String,
        message: String,
        placeHolder: String,
        actionHandler: ((String) -> Void)? = nil) {

        // Init alertController
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Set Ok action with handler
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            guard
                let textField = alertController.textFields?.first,
                let boardName = textField.text
            else {
                actionHandler?("")
                return
            }
            actionHandler?(boardName)
        }

        // Set Cancel action
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        // Add Text Field
        alertController.addTextField(configurationHandler: { $0.placeholder = placeHolder })

        // Add Buttons
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)

        // Present
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: Action

    fileprivate func createNewBoard(name: String) {
        let newBoard = dataManager.createNewBoard(name: name, order: boards.count)
        boards.append(newBoard)
    }

    fileprivate func deleteBoard(board: Board) {
        boards = dataManager.deleteBoard(board: board, in: boards)
    }

    fileprivate func addNewTask(
        detail: String,
        into board: Board,
        at boardCell: BoardCollectionViewCell) {

        if dataManager.createTaskInBoard(detail: detail, in: board) {
            boardCell.reloadData()
        }
    }
}

extension TodoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCell", for: indexPath) as? BoardCollectionViewCell else {
            fatalError("BoardCollectionViewCell should be registered!")
        }
        cell.setupContent(with: boards[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension TodoViewController: BoardCollectionViewCellDelegate {
    func cell(_ boardCell: BoardCollectionViewCell, selectMoreActionOn board: Board) {
        let actionSheetController = UIAlertController(
            title: "Select an action",
            message: nil,
            preferredStyle: .actionSheet
        )

        let addCardAction = UIAlertAction(title: "Add Card", style: .default) { [weak self] _ in
            self?.showAddTaskAlert(for: board, at: boardCell)
        }

        let deleteBoardAction = UIAlertAction(title: "Delete Board", style: .destructive) { [weak self] _ in
            self?.deleteBoard(board: board)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheetController.addAction(addCardAction)
        actionSheetController.addAction(deleteBoardAction)
        actionSheetController.addAction(cancelAction)

        DispatchQueue.main.async {
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
}
