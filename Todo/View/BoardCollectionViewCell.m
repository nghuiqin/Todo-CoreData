//
//  TaskBoardCollectionViewCell.m
//  Todo
//
//  Created by Ng Hui Qin on 5/1/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//

#import "BoardCollectionViewCell.h"
#import "Task+CoreDataClass.h"
#import "TaskTableViewCell.h"
#import "Todo-Swift.h"

@interface BoardCollectionViewCell () <UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate>
/**
 Task list view
 */
@property (strong, nonatomic) UITableView * taskListView;

/**
 Board's name label
 */
@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIButton *moreButton;

@property (weak, nonatomic) Board *board;
@end

@implementation BoardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    self.taskListView = [[UITableView alloc] init];
    [self.taskListView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.taskListView.frame = CGRectMake(0, 30, self.bounds.size.width, self.bounds.size.height - 40);
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 40, 30)];
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 35, 0, 35, 30)];
    [self.moreButton setTitle:@"More" forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(onMoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.moreButton];
    [self.contentView addSubview:self.taskListView];
    self.taskListView.dataSource = self;
    self.taskListView.dragInteractionEnabled = YES;
    self.taskListView.dragDelegate = self;
    self.taskListView.dropDelegate = self;
}

- (void)setupContentWith:(Board *)board {
    self.board = board;
    self.nameLabel.text = board.name;
    [self reloadData];
}

- (void)reloadData {
    [self.taskListView reloadData];
}

#pragma mark - Selectors
- (void)onMoreButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:selectMoreActionOn:)]) {
        [self.delegate cell:self selectMoreActionOn:self.board];
    }
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.board.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    Task *task = self.board.tasks[indexPath.row];
    cell.textLabel.text = task.detail;
    return cell;
}

#pragma mark - UITableView Drag Delegate

- (NSArray<UIDragItem *> *)tableView:(UITableView *)tableView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    Task *task = self.board.tasks[indexPath.row];
    NSData *data = [task.detail dataUsingEncoding:NSUTF8StringEncoding];
    NSItemProvider *item = [[NSItemProvider alloc] initWithItem:data typeIdentifier:@"Task"];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:item];
    [session setLocalContext:@{@"tableView": tableView,
                               @"indexPath": indexPath,
                               @"board": self.board}];

    return [NSArray arrayWithObject:dragItem];
}

#pragma makr - UITableView Drop Delegate

- (void)tableView:(UITableView *)tableView performDropWithCoordinator:(id<UITableViewDropCoordinator>)coordinator {

    if ([coordinator.session hasItemsConformingToTypeIdentifiers:@[@"Task"]]) {

        // Skip if item is null
        id<UITableViewDropItem> item = [coordinator.items firstObject];
        if (item == nil) {
            return;
        }

        NSIndexPath *sourceIndexPath = item.sourceIndexPath;
        NSIndexPath *destinationIndexPath = coordinator.destinationIndexPath;

        NSDictionary *context = (NSDictionary *)coordinator.session.localDragSession.localContext;
        UITableView *originalTableView = (UITableView *)context[@"tableView"];
        Board *originalBoard = (Board *)context[@"board"];

        /// Same TableView
        if (originalBoard == self.board) {
            Task *draggingTask = self.board.tasks[sourceIndexPath.row];
            [self.taskListView beginUpdates];
            [self.board removeObjectFromTasksAtIndex:sourceIndexPath.row];
            [self.board insertObject:draggingTask inTasksAtIndex:destinationIndexPath.row];
            [self.taskListView deleteRowsAtIndexPaths:@[sourceIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.taskListView
             insertRowsAtIndexPaths:@[destinationIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.taskListView endUpdates];

        /// Move data from table to another table
        } else if (sourceIndexPath == nil && destinationIndexPath != nil) {
            NSIndexPath *indexPath = (NSIndexPath *)context[@"indexPath"];
            Task *draggingTask = originalBoard.tasks[indexPath.row];
            [self tableView:originalTableView removeSourceAtIndex:indexPath inBoard:originalBoard];
            [self.taskListView beginUpdates];
            [self.board insertObject:draggingTask inTasksAtIndex:destinationIndexPath.row];
            [self.taskListView insertRowsAtIndexPaths:@[destinationIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.taskListView endUpdates];

            /// Insert data from table to another table
        } else if (sourceIndexPath == nil && destinationIndexPath == nil) {
            NSIndexPath *indexPath = (NSIndexPath *)context[@"indexPath"];
            Task *draggingTask = originalBoard.tasks[indexPath.row];
            [self tableView:originalTableView removeSourceAtIndex:indexPath inBoard:originalBoard];
            [self.board addTasksObject:draggingTask];
            [self reloadData];
        }

        [self.delegate taskDidMoved];
    }
}

- (void)tableView:(UITableView *)tableView removeSourceAtIndex:(NSIndexPath *)indexPath inBoard:(Board *)board {
    [tableView beginUpdates];
    [board removeObjectFromTasksAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (UITableViewDropProposal *)tableView:(UITableView *)tableView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    return [[UITableViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UITableViewDropIntentInsertAtDestinationIndexPath];
}

@end
