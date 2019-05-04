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

@interface BoardCollectionViewCell () <UITableViewDataSource>
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

@end
