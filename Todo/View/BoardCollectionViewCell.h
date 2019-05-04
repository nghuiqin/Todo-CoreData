//
//  TaskCollectionViewCell.h
//  Todo
//
//  Created by Ng Hui Qin on 5/1/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@class BoardCollectionViewCell;

@protocol BoardCollectionViewCellDelegate <NSObject>

- (void)cell:(BoardCollectionViewCell *) boardCell selectMoreActionOn:(Board *)board;

@end

@interface BoardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<BoardCollectionViewCellDelegate> delegate;

- (void)setupContentWith:(Board *) board;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
