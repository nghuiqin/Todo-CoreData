//
//  Board+CoreDataProperties.m
//  Todo
//
//  Created by Ng Hui Qin on 5/4/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//
//

#import "Board+CoreDataProperties.h"

@implementation Board (CoreDataProperties)

+ (NSFetchRequest<Board *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Board"];
}

@dynamic name;
@dynamic order;
@dynamic tasks;

@end
