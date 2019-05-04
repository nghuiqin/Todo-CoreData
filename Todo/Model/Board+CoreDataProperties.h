//
//  Board+CoreDataProperties.h
//  Todo
//
//  Created by Ng Hui Qin on 5/4/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//
//

#import "Board+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Board (CoreDataProperties)

+ (NSFetchRequest<Board *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t order;
@property (nullable, nonatomic, retain) NSOrderedSet<Task *> *tasks;

@end

@interface Board (CoreDataGeneratedAccessors)

- (void)insertObject:(Task *)value inTasksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTasksAtIndex:(NSUInteger)idx;
- (void)insertTasks:(NSArray<Task *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTasksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTasksAtIndex:(NSUInteger)idx withObject:(Task *)value;
- (void)replaceTasksAtIndexes:(NSIndexSet *)indexes withTasks:(NSArray<Task *> *)values;
- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSOrderedSet<Task *> *)values;
- (void)removeTasks:(NSOrderedSet<Task *> *)values;

@end

NS_ASSUME_NONNULL_END
