//
//  Task+CoreDataProperties.h
//  Todo
//
//  Created by Ng Hui Qin on 5/4/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//
//

#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created_at;
@property (nullable, nonatomic, copy) NSString *detail;
@property (nullable, nonatomic, retain) Board *board;

@end

NS_ASSUME_NONNULL_END
