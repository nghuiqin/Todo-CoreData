//
//  DraggableCollectionView.m
//  Todo
//
//  Created by Ng Hui Qin on 5/6/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//

#import "DraggableCollectionView.h"

@implementation DraggableCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout];
    if (self) {
        [self addLongPressGesture];
    }
    return self;
}

- (void)addLongPressGesture {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:longPressGesture];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *selectedIndexPath = [self indexPathForItemAtPoint:[gesture locationInView:self]];
            if (selectedIndexPath == nil) {
                return;
            }
            [self beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            break;
        }

        case UIGestureRecognizerStateChanged:
            [self updateInteractiveMovementTargetPosition:[gesture locationInView:self]];
            break;

        case UIGestureRecognizerStateEnded:
            [self endInteractiveMovement];
            break;

        default:
            [self cancelInteractiveMovement];
            break;
    }
}
@end
